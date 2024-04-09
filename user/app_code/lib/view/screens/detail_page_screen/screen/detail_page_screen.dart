import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:app_code/view/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/view/modules/utils/models/category_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../modules/utils/componets/sales_user_componet.dart';
import '../../../modules/utils/controllers/sales_user_controller.dart';

class DetailPageScreen extends StatelessWidget {
  Map<String, dynamic> data;
  DetailPageScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> data =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    CategoryDataModel product = data['data'];
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(w * 0.04),
          color: data['color'],
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xffefebe2),
                        ),
                      ),
                      icon: const Icon(Icons.close),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StreamBuilder(
                              stream: FCMHelper.fcmHelper.getProductHistory(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  QuerySnapshot<Map<String, dynamic>>? data =
                                      snapshot.data;

                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>>
                                      allHistory = data?.docs ?? [];

                                  return Container(
                                    height: h,
                                    width: w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "History",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: textScaler.scale(25),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: allHistory.length,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> history =
                                                  allHistory[index].data();
                                              if ((product.title ==
                                                  history['title'])) {
                                                return Card(
                                                  child: ListTile(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    title: Text(
                                                      history['title'],
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        const Text(
                                                          "Date: ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${history['date']}",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                      "Qty: ${history['qty']}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
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
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xffefebe2),
                        ),
                      ),
                      icon: const Icon(Icons.electric_bolt_outlined),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.purple,
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Container(
                padding: EdgeInsets.all(w * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.08),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffeef4e1),
                          borderRadius: BorderRadius.circular(w * 0.04),
                        ),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Image.network(
                          product.image,
                          height: h * 0.15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: w * 0.025,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  product.category,
                                  style: TextStyle(
                                    fontSize: textScaler.scale(15),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${product.qty} Qty",
                                  style: TextStyle(
                                    fontSize: textScaler.scale(15),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${product.price}.00",
                                  style: TextStyle(
                                    fontSize: textScaler.scale(18),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<SalesUserController>(context,
                                            listen: false)
                                        .getProductData(
                                      category: product.category,
                                      title: product.title,
                                      price: product.price,
                                      image: product.image,
                                    );

                                    // Navigator.of(context)
                                    //     .pushNamed(Routes.salesPageScreen);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const SalesUserComponet(),
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        reverseTransitionDuration:
                                            const Duration(seconds: 1),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.ease;

                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(h * 0.013),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(w * 0.06),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.white,
                                          size: h * 0.02,
                                        ),
                                        SizedBox(
                                          width: w * 0.01,
                                        ),
                                        const Text(
                                          "Sale",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: h * 0.015),
                child: Container(
                  padding: EdgeInsets.all(h * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.06),
                  ),
                  child: Text(
                    product.des,
                    style: TextStyle(
                      fontSize: textScaler.scale(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
