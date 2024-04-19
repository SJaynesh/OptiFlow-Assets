import 'dart:developer';

import 'package:app_code/view/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/view/modules/utils/models/profile_page_model.dart';
import 'package:app_code/view/screens/edit_page_screen/screen/edit_page_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/edit_page_controller.dart';

class SettingUserComponet extends StatelessWidget {
  const SettingUserComponet({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: StreamBuilder(
        stream: FCMHelper.fcmHelper.getUserProfileData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          // else if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Shimmer.fromColors(
          //     baseColor: Colors.grey.shade300,
          //     highlightColor: Colors.grey.shade100,
          //     child: Container(
          //       height: h * 0.45,
          //       width: w,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //           bottomLeft: Radius.circular(w * 0.15),
          //         ),
          //         color: Colors.white,
          //       ),
          //     ),
          //   );
          // }
          else if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
            Map<String, dynamic> userData = data?.data() ?? {};
            log("Values : $userData");
            ProfilePageModel profilePageModel =
                ProfilePageModel.fromMap(userData);
            return Stack(
              children: [
                Container(
                  height: h * 0.45,
                  width: w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        profilePageModel.bgImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(w * 0.15),
                      bottomRight: Radius.circular(w * 0.15),
                    ),
                  ),
                  child: Container(
                    height: h * 0.45,
                    width: w,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xff3a446f).withOpacity(0.65),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(w * 0.15),
                        bottomRight: Radius.circular(w * 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(
                              flex: 4,
                            ),
                            Text(
                              "Your Profile",
                              style: TextStyle(
                                fontSize: textScaler.scale(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            IconButton.outlined(
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        EditPageScreen(),
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    reverseTransitionDuration:
                                        const Duration(seconds: 1),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
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
                                Provider.of<EditPageController>(context,
                                        listen: false)
                                    .changeTheValueForDOBAndGender(
                                  dob: profilePageModel.dob,
                                  gender: profilePageModel.gender,
                                );

                                // MaterialBanner materialBanner = MaterialBanner(
                                //   content: Container(
                                //     height: h * 0.3,
                                //     width: w,
                                //     color: Colors.white,
                                //   ),
                                //   actions: [
                                //     TextButton(
                                //       onPressed: () {
                                //         ScaffoldMessenger.of(context)
                                //             .hideCurrentMaterialBanner();
                                //       },
                                //       child: const Text("Submit"),
                                //     )
                                //   ],
                                // );
                                // ScaffoldMessenger.of(context)
                                //     .showMaterialBanner(materialBanner);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.025,
                        ),
                        CircleAvatar(
                          radius: w * 0.18,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            profilePageModel.profileImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: h * 0.3,
                    width: w,
                    margin: EdgeInsets.all(h * 0.04),
                    padding: EdgeInsets.all(h * 0.02),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFF),
                      borderRadius: BorderRadius.circular(w * 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(-1, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profilePageModel.fullName,
                          style: TextStyle(
                            fontSize: textScaler.scale(25),
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          profilePageModel.userName,
                          style: TextStyle(
                            fontSize: textScaler.scale(20),
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          profilePageModel.bio,
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: h * 0.3,
                    width: w,
                    padding: EdgeInsets.all(h * 0.03),
                    child: Column(
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.email,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                "+91 ${profilePageModel.phoneNumber}",
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.cake,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.dob,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.wc_outlined,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.gender,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.work,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.department,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.apartment,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.companyName,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: w * 0.08),
                              child: Text(
                                profilePageModel.location,
                                style: TextStyle(
                                  fontSize: textScaler.scale(14),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center();
        },
      ),
    );
  }
}
