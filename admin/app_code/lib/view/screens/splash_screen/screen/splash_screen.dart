import 'dart:async';
import 'dart:developer';

import 'package:app_code/modules/utils/globals/routes.dart';
import 'package:app_code/view/screens/splash_screen/utils/splash_screen_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../modules/utils/helpers/firebase_auth_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      (FireBaseAuthHelper.firebaseAuth.firebase.currentUser != null)
          ? Navigator.of(context).pushReplacementNamed(Routes.homePageScreen)
          : Navigator.of(context).pushReplacementNamed(Routes.introScreen);
    });

    Size size = MediaQuery.of(context).size;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    double h = size.height;
    double w = size.width;
    log("*******************");
    log("Screen Size : $size");
    log("Screen Size : ${size.height}");
    log("Screen Size : ${size.width}");
    log("*******************");
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    splash_screen_image,
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
