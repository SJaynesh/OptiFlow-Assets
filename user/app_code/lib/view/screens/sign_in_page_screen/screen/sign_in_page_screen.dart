import 'dart:developer';

import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:app_code/view/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modules/utils/controllers/sign_in_page_controller.dart';
import '../../../modules/utils/helpers/fcm_helper.dart';

class SignInPageScreen extends StatelessWidget {
  SignInPageScreen({super.key});

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var providerFalse =
        Provider.of<SignInPageController>(context, listen: false);
    var providerTrue = Provider.of<SignInPageController>(context, listen: true);
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock,
                  size: textScaler.scale(20),
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Optiflow Accounts",
                        style: TextStyle(
                          fontSize: textScaler.scale(16),
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        "accounts.optiflow.com",
                        style: TextStyle(
                          fontSize: textScaler.scale(12),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const Icon(
            Icons.share,
            color: Colors.white,
          ),
          SizedBox(
            width: w * 0.05,
          ),
          const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          SizedBox(
            width: w * 0.025,
          ),
        ],
        backgroundColor: const Color(0xff1e2736),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(
              textScaler.scale(30),
            ),
            child: Form(
              key: signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/splash_images/splash_image.png",
                    height: h * 0.05,
                  ),
                  const Spacer(),
                  Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: textScaler.scale(30),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1e2736),
                    ),
                  ),
                  Text(
                    "to access Optiflow Inventory",
                    style: TextStyle(
                      fontSize: textScaler.scale(20),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff1e2736),
                    ),
                  ),
                  const Spacer(),
                  TextFormField(
                    controller: providerTrue.signInPageModel.userIdController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        (val!.isEmpty) ? "please enter your user id" : null,
                    decoration: InputDecoration(
                      hintText: "User ID",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.withOpacity(0.4),
                        letterSpacing: 1,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextFormField(
                    controller: providerTrue.signInPageModel.passwordController,
                    obscureText: providerTrue.signInPageModel.showPassword,
                    // obscuringCharacter: "*",
                    validator: (val) =>
                        (val!.isEmpty) ? "please enter your password" : null,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Email password",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.withOpacity(0.4),
                        letterSpacing: 1,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          providerFalse.changePasswordVisibled();
                        },
                        icon: (providerTrue.signInPageModel.showPassword)
                            ? const Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Theme(
                          data: ThemeData(
                            useMaterial3: false,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (signInFormKey.currentState!.validate()) {
                                String userId = providerTrue
                                    .signInPageModel.userIdController.text
                                    .trim();
                                String password = providerTrue
                                    .signInPageModel.passwordController.text
                                    .trim();

                                log(userId);
                                log(password);

                                Map<String, dynamic> res =
                                    await FireBaseAuthHelper.firebaseAuth
                                        .signInWithUserIdAddress(
                                            userId: userId, password: password);

                                if (res['user'] != null) {
                                  if (context.mounted) {
                                    providerFalse.changeCircularVisiblity();
                                    Future.delayed(
                                      const Duration(seconds: 5),
                                      () async {
                                        await getUserDepartment();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                Routes.homePageScreen,
                                                (route) => false);
                                        providerFalse.changeCircularVisiblity();
                                      },
                                    );
                                  }
                                }
                                if (res['error'] != null) {
                                  providerFalse.changeCircularVisiblity();
                                  Future.delayed(
                                    const Duration(seconds: 5),
                                    () {
                                      providerFalse.changeCircularVisiblity();
                                      SnackBar snackBar = SnackBar(
                                        content:
                                            Text("ERROR : ${res['error']}"),
                                        backgroundColor: Colors.redAccent,
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                  );
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: textScaler.scale(15),
                                bottom: textScaler.scale(15),
                              ),
                              child: const Text(
                                "Sign in",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(
                    flex: 15,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: providerTrue.signInPageModel.circularVisibled,
            child: Container(
              height: h,
              width: w,
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserDepartment() async {
    if (FireBaseAuthHelper.firebaseAuth.firebase.currentUser != null) {
      String email =
          FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;

      log("EMAIL : $email");
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
}
