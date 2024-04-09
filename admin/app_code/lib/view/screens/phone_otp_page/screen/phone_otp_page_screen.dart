import 'dart:developer';

import 'package:app_code/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../modules/utils/globals/routes.dart';

class PhoneOtpPage extends StatelessWidget {
  PhoneOtpPage({super.key});

  String code = "";

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(h * 0.025),
        child: Column(
          children: [
            Image.asset(
              "assets/images/splash_images/phone.gif",
              height: h * 0.3,
            ),
            Text(
              "Phone Verification",
              style: TextStyle(
                fontSize: textScaler.scale(25),
                fontWeight: FontWeight.w900,
                color: const Color(0xff1e2736),
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            Text(
              "We need to register your phone without getting",
              style: TextStyle(
                fontSize: textScaler.scale(16),
                fontWeight: FontWeight.w400,
                color: const Color(0xff1e2736),
              ),
            ),
            Text(
              "started  !",
              style: TextStyle(
                fontSize: textScaler.scale(16),
                fontWeight: FontWeight.w400,
                color: const Color(0xff1e2736),
              ),
            ),
            const Spacer(),
            Container(
              width: w * 0.8,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
                separatorBuilder: (index) => Container(
                  height: 64,
                  width: 1,
                  color: Colors.white,
                ),
                defaultPinTheme: PinTheme(
                  width: w * 0.15,
                  height: h * 0.075,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(159, 132, 193, 0.8),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: w * 0.15,
                  height: h * 0.075,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(124, 102, 152, 1),
                  ),
                ),
                // submittedPinTheme: PinTheme(
                //   width: 56,
                //   height: 56,
                //   textStyle: const TextStyle(
                //       fontSize: 20,
                //       color: Color.fromRGBO(30, 60, 87, 1),
                //       fontWeight: FontWeight.w600),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
                //     borderRadius: BorderRadius.circular(8),
                //     color: Color.fromRGBO(234, 239, 243, 1),
                //   ),
                // ),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            SizedBox(
              width: w,
              height: h * 0.06,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xffffc92d),
                  ),
                ),
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: data["verificationId"],
                      smsCode: code,
                    );

                    await FireBaseAuthHelper.firebaseAuth.firebase
                        .signInWithCredential(credential);

                    Map<String, dynamic> res = await FireBaseAuthHelper
                        .firebaseAuth
                        .signInWithEmailAddress(
                            email: data['email'], password: data['password']);

                    Navigator.pushNamed(
                      context,
                      Routes.organizationScreen,
                      arguments: data,
                    );
                  } catch (e) {
                    log("ERROR : $e");
                    SnackBar snackBar = const SnackBar(
                      content: Text(
                          "Your Phone Number is Invalid. Please Check Number.🥲🥲🥲"),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  "Verify phone number",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textScaler.scale(18),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const Spacer(
              flex: 15,
            ),
          ],
        ),
      ),
    );
  }
}
