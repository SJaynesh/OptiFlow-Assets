import 'dart:developer';

import 'package:app_code/modules/utils/controllers/sign_up_page_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../controllers/organization_page_controller.dart';
import '../globals/routes.dart';
import '../models/sign_up_page_model.dart';

mixin AuthMixin {
  Future<void> signInWithGoogle();

  Future<Map<String, dynamic>> signUpWithEmailAddress(
      {required String email, required String password});

  Future<Map<String, dynamic>> signInWithEmailAddress(
      {required String email, required String password});

  Future<void> signInWithMobileOTP(
      {required String phoneNumber, required BuildContext context});
}

class FireBaseAuthHelper with AuthMixin {
  FireBaseAuthHelper._();

  static final FireBaseAuthHelper firebaseAuth = FireBaseAuthHelper._();

  FirebaseAuth firebase = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Google Auth
  @override
  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential userCredential =
        await firebase.signInWithCredential(credential);
  }

  // Sign Up Auth
  @override
  Future<Map<String, dynamic>> signUpWithEmailAddress(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebase
          .createUserWithEmailAndPassword(email: email, password: password);
      res['user'] = userCredential.user;
    } on FirebaseAuthException catch (e) {
      res['error'] = e.code;
    }
    return res;
  }

  // Sign In Auth
  @override
  Future<Map<String, dynamic>> signInWithEmailAddress(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebase.signInWithEmailAndPassword(
          email: email, password: password);
      res['user'] = userCredential.user;
    } on FirebaseAuthException catch (e) {
      res['error'] = e.code;
    }
    return res;
  }

  // Sign In Mobile
  @override
  Future<void> signInWithMobileOTP(
      {required String phoneNumber, required BuildContext context}) async {
    await firebase.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // await firebase.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) {
        if (error.code == 'invalid-phone-number') {
          log('The provided phone number is not valid .${error.code}');
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
        } else {
          log("ERROR : ${error.code}");
          SnackBar snackBar = SnackBar(
            content: Text(
                "${error.code} This Resion Not Possible Phone Number Verification.😔😔😔"),
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        Size size = MediaQuery.of(context).size;
        TextScaler textScale = MediaQuery.of(context).textScaler;
        double h = size.height;
        double w = size.width;
        TextEditingController OTPController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(w * 0.035),
                ),
              ),
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: w * 0.09,
                    child: Image.asset(
                        "assets/images/sign_up_page_images/verify_mobile.png"),
                  ),
                ],
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Verify your mobile number",
                    style: TextStyle(
                      fontSize: textScale.scale(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Enter the OTP sent to your mobile number.",
                    style: TextStyle(
                      fontSize: textScale.scale(12),
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: h * 0.02,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  SizedBox(
                    height: h * 0.05,
                    width: w * 0.45,
                    child: TextFormField(
                      controller: OTPController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Enter OTP",
                        hintStyle: TextStyle(
                          height: 1,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: Theme(
                    data: ThemeData(
                      useMaterial3: false,
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        Provider.of<SignUpPageController>(context,
                                listen: false)
                            .getLoadValue(val: true);
                        Future.delayed(
                          const Duration(seconds: 2),
                          () async {
                            String smsCode = OTPController.text.trim();
                            log(smsCode);
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: smsCode,
                            );
                            try {
                              UserCredential userCredential = await firebase
                                  .signInWithCredential(credential);
                              User? user = userCredential.user;
                              if (user != null) {
                                Navigator.pop(context);

                                SnackBar snackBar = const SnackBar(
                                  content: Text(
                                      "Phone Number Verification Successfully... 😂😂😂"),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } on FirebaseAuthException catch (e) {
                              log("ERROR : ${e.code}");
                              Navigator.pop(context);
                              Navigator.pop(context);
                              SnackBar snackBar = SnackBar(
                                content: Text(
                                    "Phone Number Verification not Successfully... ${e.code} 😡😡😡"),
                                backgroundColor: Colors.redAccent,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                            left: textScale.scale(18),
                            right: textScale.scale(18),
                          ),
                        ),
                      ),
                      child: (Provider.of<SignUpPageController>(context,
                                  listen: true)
                              .signUpPageModel
                              .load)
                          ? Transform.scale(
                              scale: 0.7,
                              child: const CircularProgressIndicator(),
                            )
                          : const Text("Verify OTP"),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> signOut() async {
    await firebase.signOut();
    await googleSignIn.signOut();
  }
}
