import 'dart:developer';

import 'package:app_code/modules/utils/controllers/carousal_slider_controller.dart';
import 'package:app_code/modules/utils/globals/routes.dart';
import 'package:app_code/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:app_code/view/screens/intro_page_screen/utils/intro_page_screen_variable.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class IntroPageScreen extends StatelessWidget {
  const IntroPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    var providerFalse =
        Provider.of<CarousalSliderController>(context, listen: false);
    var providerTrue =
        Provider.of<CarousalSliderController>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(h * 0.025),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                    items: carousel_slider_list
                        .map(
                          (e) => Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(e),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      animateToClosest: false,
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      autoPlayCurve: Curves.easeInBack,
                      height: h * 0.7,
                      viewportFraction: 1,
                      onPageChanged: (val, _) {
                        providerFalse.getCarousalSliderValue(index: val);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                        6,
                        (index) => Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child:
                              (index == providerTrue.carousalSliderModel.index)
                                  ? CircleAvatar(
                                      radius: w * 0.0135,
                                      backgroundColor: const Color(0xff1e2736),
                                    )
                                  : CircleAvatar(
                                      radius: w * 0.01,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.35),
                                    ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await FireBaseAuthHelper.firebaseAuth
                          .signInWithGoogle()
                          .then((value) {
                        Navigator.of(context)
                            .pushNamed(Routes.organizationScreen, arguments: {
                          'email': FireBaseAuthHelper
                              .firebaseAuth.firebase.currentUser?.email,
                          'password': ""
                        });
                      });
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2.5),
                      shape: MaterialStateProperty.all(
                        const BeveledRectangleBorder(),
                      ),
                    ),
                    icon: Image.asset(
                      intro_page_google_logo,
                      height: 20,
                    ),
                    label: const Text("Sign in with Google"),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.signUpScreen);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xff1e2736),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.015),
                            ),
                          ),
                        ),
                        child: Text(
                          "  Sign Up  ",
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            letterSpacing: 0.5,
                            fontSize: textScaler.scale(14),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: w * 0.055,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.signInScreen);
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                            BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w * 0.015),
                            ),
                          ),
                        ),
                        child: Text(
                          "  Login  ",
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.5,
                            fontSize: textScaler.scale(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
