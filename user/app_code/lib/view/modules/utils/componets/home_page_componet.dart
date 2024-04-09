import 'dart:developer';

import 'package:app_code/view/modules/utils/controllers/product_controller.dart';
import 'package:app_code/view/screens/detail_page_screen/screen/detail_page_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../helpers/fcm_helper.dart';
import '../models/category_data_model.dart';

class HomePageComponet extends StatefulWidget {
  const HomePageComponet({super.key});

  @override
  State<HomePageComponet> createState() => _HomePageComponetState();
}

class _HomePageComponetState extends State<HomePageComponet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F2F2),
        surfaceTintColor: Colors.white,
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
          CircleAvatar(
            radius: w * 0.07,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: w * 0.058,
              backgroundImage: const NetworkImage(
                  "https://avatars.githubusercontent.com/u/115562979?v=4"),
            ),
          ),
          SizedBox(
            width: w * 0.04,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Consumer<ProductController>(
          builder: (context, controller, child) {
            return StreamBuilder(
              stream: FCMHelper.fcmHelper.getUserDepartmentData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "${snapshot.data}",
                      style: TextStyle(
                        fontSize: textScaler.scale(25),
                        color: Colors.black,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
                  Map<String, dynamic> allData = data?.data() ?? {};
                  log("DAIRY DATA: $allData");
                  List allDairyData = allData[userDeptName];

                  controller.productModel.Products = allDairyData
                      .map(
                        (e) => CategoryDataModel.fromMap(data: e),
                      )
                      .toList();

                  controller.getCategoryData(
                    categoryData: controller.productModel.Products
                        .map((e) => e.category)
                        .toList(),
                  );

                  controller.productModel.Categories = controller
                      .productModel.Products
                      .map((e) => e.category)
                      .toList()
                      .toSet()
                      .toList();

                  controller.getProductAvailableItems();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                            stream: FCMHelper.fcmHelper.getEarningAndSales(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                DocumentSnapshot<Map<String, dynamic>>? data =
                                    snapshot.data;
                                Map<String, dynamic> summary =
                                    data?.data() ?? {};
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      '"Automate Your Inventory, ',
                                      style: GoogleFonts.vollkorn(
                                        textStyle: TextStyle(
                                          fontSize: textScaler.scale(20),
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' Simplify Your Life.',
                                          style: GoogleFonts.vollkorn(
                                            textStyle: TextStyle(
                                              fontSize: textScaler.scale(20),
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '"',
                                          style: GoogleFonts.vollkorn(
                                            textStyle: TextStyle(
                                              fontSize: textScaler.scale(23),
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff181657),
                                        borderRadius:
                                            BorderRadius.circular(w * 0.03),
                                      ),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: h * 0.025,
                                              left: w * 0.03,
                                            ),
                                            child: Text(
                                              "Summary",
                                              style: TextStyle(
                                                fontSize: textScaler.scale(20),
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: h * 0.03,
                                              left: w * 0.035,
                                              right: w * 0.035,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Department",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffaeaddf),
                                                  ),
                                                ),
                                                Text(
                                                  "Items",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffaeaddf),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: w * 0.035,
                                              right: w * 0.035,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "DAIRY & FROZEN.",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                  ),
                                                ),
                                                Text(
                                                  "${controller.productModel.itemsLength}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: h * 0.015,
                                              left: w * 0.035,
                                              right: w * 0.035,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Earning",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffaeaddf),
                                                  ),
                                                ),
                                                Text(
                                                  "Sales",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        const Color(0xffaeaddf),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: w * 0.035,
                                              right: w * 0.035,
                                              bottom: h * 0.025,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${summary['earning']}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                  ),
                                                ),
                                                Text(
                                                  "${summary['sales']}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(16),
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xffFFFFFF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                );
                              }
                              return const Center();
                            },
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...controller.productModel.Categories.map(
                                  (e) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(
                                          fontSize: textScaler.scale(22),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ...controller.productModel.Products
                                                .map(
                                              (element) {
                                                return (element.category == e)
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            PageRouteBuilder(
                                                              pageBuilder: (context,
                                                                      animation,
                                                                      secondaryAnimation) =>
                                                                  DetailPageScreen(
                                                                data: {
                                                                  'color': Colors
                                                                      .primaries[
                                                                          controller.productModel.Products.indexOf(element) %
                                                                              18]
                                                                      .withOpacity(
                                                                          0.3),
                                                                  'data':
                                                                      element,
                                                                },
                                                              ),
                                                              transitionDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              reverseTransitionDuration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              transitionsBuilder:
                                                                  (context,
                                                                      animation,
                                                                      secondaryAnimation,
                                                                      child) {
                                                                const begin =
                                                                    Offset(1.0,
                                                                        0.0);
                                                                const end =
                                                                    Offset.zero;
                                                                const curve =
                                                                    Curves.ease;

                                                                var tween = Tween(
                                                                        begin:
                                                                            begin,
                                                                        end:
                                                                            end)
                                                                    .chain(CurveTween(
                                                                        curve:
                                                                            curve));

                                                                return SlideTransition(
                                                                  position: animation
                                                                      .drive(
                                                                          tween),
                                                                  child: child,
                                                                );
                                                              },
                                                            ),
                                                          );
                                                          // Navigator.pushNamed(
                                                          //     context,
                                                          //     Routes
                                                          //         .detailPageScreen,
                                                          //     arguments: {
                                                          //       'color': Colors
                                                          //           .primaries[controller
                                                          //                   .productModel
                                                          //                   .Products
                                                          //                   .indexOf(
                                                          //                       element) %
                                                          //               18]
                                                          //           .withOpacity(
                                                          //               0.3),
                                                          //       'data': element,
                                                          //     });
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height: h * 0.3,
                                                              width: w * 0.6,
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: h * 0.03,
                                                                bottom:
                                                                    h * 0.01,
                                                                left: w * 0.04,
                                                                right: w * 0.04,
                                                              ),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .primaries[controller
                                                                            .productModel
                                                                            .Products
                                                                            .indexOf(
                                                                                element) %
                                                                        18]
                                                                    .withOpacity(
                                                                        0.25),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(h *
                                                                            0.035),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left: w *
                                                                              0.028,
                                                                          right:
                                                                              w * 0.028,
                                                                          top: h *
                                                                              0.0065,
                                                                          bottom:
                                                                              h * 0.0065,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              const Color(0xffff9f2a),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                        ),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "50%",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                textScaler.scale(18),
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .favorite_border_rounded,
                                                                          color:
                                                                              Colors.grey,
                                                                          size: h *
                                                                              0.033,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Image
                                                                        .network(
                                                                      element
                                                                          .image,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: h * 0.01,
                                                                left: w * 0.025,
                                                              ),
                                                              child: Text(
                                                                element.title,
                                                                style: TextStyle(
                                                                    fontSize: textScaler
                                                                        .scale(
                                                                            16),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: w * 0.025,
                                                                top: h * 0.01,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "₹${element.price}.00",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          textScaler
                                                                              .scale(16),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        w * 0.2,
                                                                  ),
                                                                  Text(
                                                                    "${element.qty} Qty",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          textScaler
                                                                              .scale(16),
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.05,
                                      ),
                                    ],
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
          },
        ),
      ),
    );
  }
}
