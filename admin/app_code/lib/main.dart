import 'package:app_code/modules/utils/controllers/add_product_page_controller.dart';
import 'package:app_code/modules/utils/controllers/add_user_controller.dart';
import 'package:app_code/modules/utils/controllers/bottom_navigation_bar_controller.dart';
import 'package:app_code/modules/utils/controllers/carousal_slider_controller.dart';
import 'package:app_code/modules/utils/controllers/department_page_controller.dart';
import 'package:app_code/modules/utils/controllers/organization_page_controller.dart';
import 'package:app_code/modules/utils/controllers/sign_in_page_controller.dart';
import 'package:app_code/modules/utils/controllers/sign_up_page_controller.dart';
import 'package:app_code/modules/utils/globals/routes.dart';
import 'package:app_code/view/screens/home_page_screen/screen/home_page_screen.dart';
import 'package:app_code/view/screens/organization_page_screen/screen/organization_page_screen.dart';
import 'package:app_code/view/screens/phone_otp_page/screen/phone_otp_page_screen.dart';
import 'package:app_code/view/screens/sign_in_page_screen/screen/sign_in_page_screen.dart';
import 'package:app_code/view/screens/sign_up_page_screen/screen/sign_up_page_screen.dart';
import 'package:app_code/view/screens/splash_screen/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'view/screens/intro_page_screen/screen/intro_page_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const AdminPanelApp(),
  );
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CarousalSliderController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignInPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrganizationPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationBarController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddUserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepartmentPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AllProductPageController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          Routes.splashScreen: (context) => const SplashScreen(),
          Routes.introScreen: (context) => const IntroPageScreen(),
          Routes.signUpScreen: (context) => SignUpPageScreen(),
          Routes.signInScreen: (context) => SignInPageScreen(),
          Routes.phonePageScreen: (context) => PhoneOtpPage(),
          Routes.organizationScreen: (context) => OrganizationPageScreen(),
          Routes.homePageScreen: (context) => const HomePageScreen(),
        },
      ),
    );
  }
}
