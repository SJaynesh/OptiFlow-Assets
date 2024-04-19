import 'dart:io';

import 'package:app_code/view/modules/utils/controllers/request_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../globals/routes.dart';
import '../helpers/fcm_helper.dart';
import '../helpers/firebase_auth_helper.dart';

class RequestUserComponet extends StatelessWidget {
  RequestUserComponet({super.key});

  GlobalKey<FormState> requestUserKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: const Color(0xffF2F2F2),
        title: FutureBuilder(
          future: FCMHelper.fcmHelper.getAdminData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                "${snapshot.error}",
                style: TextStyle(
                  fontSize: textScaler.scale(23),
                  fontWeight: FontWeight.w800,
                ),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
              Map<String, dynamic> adminData = data?.data() ?? {};
              return Text(
                "${adminData['Company Name']}",
                style: TextStyle(
                  fontSize: textScaler.scale(20),
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Container();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: textScaler.scale(25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        fontSize: textScaler.scale(18),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          SizedBox(
                            width: h * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FireBaseAuthHelper.firebaseAuth
                                  .logout()
                                  .then((value) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    Routes.introPageScreen, (route) => false);
                              });
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            child: Image.asset(
              "assets/images/splash_images/splash_image.png",
              height: h * 0.03,
            ),
          ),
          SizedBox(
            width: w * 0.04,
          ),
        ],
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Request User",
              style: TextStyle(
                fontSize: textScaler.scale(20),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: Colors.grey,
              ),
            ),
            Center(
              child: Image.asset(
                "assets/images/request_page_images/request.png",
                height: h * 0.3,
              ),
            ),
            Expanded(
              child: Consumer<RequestUserController>(
                builder: (context, request, child) {
                  return Form(
                    key: requestUserKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category ",
                            style: TextStyle(
                              fontSize: textScaler.scale(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: h * 0.07,
                            child: TextFormField(
                              controller:
                                  request.requestUserModel.categoryController,
                              validator: (val) => (val!.isEmpty)
                                  ? "Enter any category.."
                                  : null,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Enter any category...",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Color(0xff322bc3),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Product ",
                            style: TextStyle(
                              fontSize: textScaler.scale(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller:
                                request.requestUserModel.productController,
                            validator: (val) =>
                                (val!.isEmpty) ? "Enter any product.." : null,
                            decoration: InputDecoration(
                              hintText: "Enter any product...",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Color(0xff322bc3),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: textScaler.scale(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller:
                                      request.requestUserModel.dateController,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff072942),
                                  ),
                                  enabled: false,
                                  cursorColor: const Color(0xff6AABDA),
                                  validator: (val) =>
                                      (val!.isEmpty) ? "Enter Date..." : null,
                                  decoration: InputDecoration(
                                    hintText: "MM/DD/YYYY",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                    errorBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('MM-dd-yyyy')
                                              .format(pickedDate);

                                      request.getDateValue(
                                          formattedDate: formattedDate);
                                      // sales.getDateValue(formattedDate: formattedDate);
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_month),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Qty",
                            style: TextStyle(
                              fontSize: textScaler.scale(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: h * 0.05,
                            width: w * 0.3,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xff35383f).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      request.decreaseQty();
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: h * 0.03,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "${request.requestUserModel.qty}",
                                      style: TextStyle(
                                        fontSize: textScaler.scale(18),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      request.increaseQty();
                                    },
                                    icon: Icon(
                                      size: h * 0.03,
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Ink(
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (requestUserKey.currentState!
                                        .validate()) {
                                      FCMHelper.fcmHelper
                                          .sendRequestProduct(
                                        category: request.requestUserModel
                                            .categoryController.text,
                                        product: request.requestUserModel
                                            .productController.text,
                                        date: request.requestUserModel
                                            .dateController.text,
                                        qty: request.requestUserModel.qty,
                                      )
                                          .then((value) {
                                        SnackBar snackBar = SnackBar(
                                          content: const Text(
                                              "Request Sent Successfully..."),
                                          backgroundColor: Colors.purpleAccent
                                              .withOpacity(0.4),
                                          dismissDirection:
                                              DismissDirection.horizontal,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      });

                                      request.clearAllValue();
                                    }
                                  },
                                  splashColor: Colors.white30,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "Request",
                                      style: TextStyle(
                                        fontSize: textScaler.scale(20),
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
