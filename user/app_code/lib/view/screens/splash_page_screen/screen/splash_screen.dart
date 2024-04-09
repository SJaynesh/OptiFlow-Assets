import 'dart:async';
import 'dart:developer';

import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:app_code/view/modules/utils/helpers/fcm_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../modules/utils/helpers/firebase_auth_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getUserDepartment();
  }

  Future<void> getUserDepartment() async {
    await FCMHelper.fcmHelper.getAdminEmailID();
    if (FireBaseAuthHelper.firebaseAuth.firebase.currentUser != null) {
      String email =
          FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;

      await FCMHelper.fcmHelper.getAdminEmailID();
      DocumentSnapshot<Map<String, dynamic>> data = await FCMHelper
          .fcmHelper.firestore
          .collection("Inventory-Management")
          .doc(adminEmail)
          .collection("Users")
          .doc(email)
          .get();

      Map<String, dynamic>? mapData = data.data();
      userDeptName = mapData!['department'] ?? "";
      log("DEPARTMENT NAME : $userDeptName");
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      (FireBaseAuthHelper.firebaseAuth.firebase.currentUser != null)
          ? Navigator.of(context).pushReplacementNamed(Routes.homePageScreen)
          : Navigator.of(context).pushReplacementNamed(Routes.introPageScreen);
    });

    Size size = MediaQuery.of(context).size;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    double h = size.height;
    double w = size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 4,
            ),
            Container(
              height: h * 0.3,
              width: w * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/splash_images/splash_image.png",
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            Expanded(
              child: Text(
                "OptiFlow Assets",
                style: GoogleFonts.moiraiOne(
                  textStyle: TextStyle(
                    fontSize: textScaler.scale(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            LinearProgressIndicator(
              minHeight: textScaler.scale(4.5),
            ),
          ],
        ),
      ),
    );
  }
}
