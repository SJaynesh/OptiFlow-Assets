import 'package:app_code/view/screens/sign_in_page_screen/screen/sign_in_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../../modules/utils/controllers/carousal_slider_controller.dart';
import '../utils/intro_page_screen_variable.dart';

class IntroPageScreen extends StatelessWidget {
  const IntroPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    items: carouselSliderList
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.signInPageScreen,
                      // );
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignInPageScreen(),
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
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(3),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                      ),
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
                    icon: const Icon(Icons.person),
                    label: const Text("Sign in"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
