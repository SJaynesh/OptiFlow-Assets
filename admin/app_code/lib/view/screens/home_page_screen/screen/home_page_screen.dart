import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_code/modules/utils/componets/all_product_page_componet.dart';
import 'package:app_code/modules/utils/componets/home_page_screen_componet.dart';
import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../modules/utils/controllers/bottom_navigation_bar_controller.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Future<void> getData() async {
    await FCMHelper.fcmHelper.getTotalEarningAndSales();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<IconData> iconList = [
    Icons.home_filled,
    Icons.shopping_cart_checkout,
    Icons.request_page,
    Icons.account_circle,
  ];

  bool isChart = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    double h = size.height;
    double w = size.width;

    var providerTrue =
        Provider.of<BottomNavigationBarController>(context, listen: true);
    var providerFalse =
        Provider.of<BottomNavigationBarController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: StreamBuilder(
          stream: FCMHelper.fcmHelper.getAdminData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
              Map<String, dynamic> userData = data!.data() ?? {};
              return Text(
                "${userData["Company Name"]}",
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
                              FireBaseAuthHelper.firebaseAuth.signOut();
                              exit(0);
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
      body: providerFalse.barModel.componet[providerTrue.barModel.index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (providerTrue.barModel.isAnimated)
          ? FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  isChart = !isChart;
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllProductPageComponet(),
                      transitionDuration: const Duration(seconds: 1),
                      reverseTransitionDuration: const Duration(seconds: 1),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
              backgroundColor: const Color(0xffffa401),
              child: Icon(
                Icons.add,
                size: h * 0.035,
              ),
            )
          : null,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: providerTrue.barModel.index,
        onTap: (index) {
          providerFalse.getNavigationBarIndexValue(val: index);
        },
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        backgroundColor: const Color(0xff383a37),
        inactiveColor: Colors.white,
        activeColor: const Color(0xffffa401),
        height: h * 0.1,
        leftCornerRadius: 40,
        rightCornerRadius: 40,
      ),
    );
  }
}
