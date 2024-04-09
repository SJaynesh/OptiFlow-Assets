import 'dart:developer';
import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_code/view/modules/utils/controllers/bottom_navigation_bar_controller.dart';
import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modules/utils/helpers/fcm_helper.dart';
import '../../../modules/utils/helpers/firebase_auth_helper.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<IconData> iconList = [
    Icons.home_filled,
    Icons.shopping_cart_checkout,
    Icons.request_page,
    Icons.account_circle,
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;

    var providerTrue =
        Provider.of<BottomNavigationBarController>(context, listen: true);
    var providerFalse =
        Provider.of<BottomNavigationBarController>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (val) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Alert !!"),
            content: const Text("Are you sure to exit?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // _canPop = true;
                  exit(0);
                },
                child: const Text("Yes"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _canPop = false;
                },
                child: const Text("No"),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: providerFalse.navigationBarModel
            .componets[providerTrue.navigationBarModel.index],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: (providerTrue.navigationBarModel.isAnimated)
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.shopPageScreen);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: const Color(0xffffa401),
                child: Icon(
                  Icons.add,
                  size: h * 0.035,
                ),
              )
            : null,
        backgroundColor: const Color(0xffF2F2F2),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          backgroundColor: const Color(0xff383a37),
          inactiveColor: Colors.white,
          activeColor: const Color(0xffffa401),
          height: h * 0.1,
          leftCornerRadius: 40,
          rightCornerRadius: 40,
          icons: iconList,
          activeIndex: providerTrue.navigationBarModel.index,
          onTap: (index) {
            providerFalse.getNavigationBarIndexValue(val: index);
          },
        ),
      ),
    );
  }
}
