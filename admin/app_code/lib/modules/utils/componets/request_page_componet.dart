import 'dart:developer';

import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/bottom_navigation_bar_controller.dart';

class RequestPageComponet extends StatelessWidget {
  const RequestPageComponet({super.key});

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    var providerTrue =
        Provider.of<BottomNavigationBarController>(context, listen: true);
    var providerFalse =
        Provider.of<BottomNavigationBarController>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FCMHelper.fcmHelper.getUserAllRequest(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error : ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
              data!.docs ?? [];

          List<RequestModel> allRequest = docs
              .map(
                (e) => RequestModel.fromMap(
                  e.data(),
                ),
              )
              .toList();
          return Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Requests (${allRequest.length})",
                  style: TextStyle(
                    fontSize: textScaler.scale(25),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Divider(),
                (allRequest.isNotEmpty)
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: allRequest.length,
                          itemBuilder: (context, index) {
                            RequestModel requestModel = allRequest[index];
                            return ListTile(
                              title: Text(
                                requestModel.product,
                                style: TextStyle(
                                  fontSize: textScaler.scale(22),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${requestModel.category} | • ${requestModel.date}",
                                    style: TextStyle(
                                      fontSize: textScaler.scale(18),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "🔗 ${requestModel.qty} qty",
                                    style: TextStyle(
                                      fontSize: textScaler.scale(16),
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton.outlined(
                                    onPressed: () {
                                      FCMHelper.fcmHelper.deleteRequest(
                                          date: requestModel.date);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                  ),
                                  IconButton.outlined(
                                    onPressed: () {
                                      RequestModel.myCategory =
                                          requestModel.category;
                                      RequestModel.myProduct =
                                          requestModel.product;
                                      RequestModel.myQty = requestModel.qty;
                                      providerFalse.getNavigationBarIndexValue(
                                          val: 1);

                                      log("REQUEST: ${RequestModel.myCategory}, ${RequestModel.myProduct}, ${RequestModel.myQty}");

                                      // FCMHelper.fcmHelper.deleteRequest(
                                      //     date: requestModel.date);
                                    },
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                        const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/splash_images/no_data.gif",
                                height: size.height * 0.3,
                              ),
                              Text(
                                "No Data Found",
                                style: TextStyle(
                                  fontSize: textScaler.scale(20),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class RequestModel {
  String category;
  String date;
  String product;
  int qty;
  static String myCategory = "";
  static String myProduct = "";
  static int myQty = 0;

  RequestModel({
    required this.category,
    required this.date,
    required this.product,
    required this.qty,
  });

  factory RequestModel.fromMap(Map<String, dynamic> data) {
    return RequestModel(
      category: data['category'],
      date: data['date'],
      product: data['product'],
      qty: data['qty'],
    );
  }
}
