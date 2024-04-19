import 'package:app_code/view/modules/utils/componets/sales_user_componet.dart';
import 'package:app_code/view/modules/utils/controllers/bottom_navigation_bar_controller.dart';
import 'package:app_code/view/modules/utils/controllers/carousal_slider_controller.dart';
import 'package:app_code/view/modules/utils/controllers/edit_page_controller.dart';
import 'package:app_code/view/modules/utils/controllers/product_controller.dart';
import 'package:app_code/view/modules/utils/controllers/request_user_controller.dart';
import 'package:app_code/view/modules/utils/controllers/sales_user_controller.dart';
import 'package:app_code/view/modules/utils/controllers/sign_in_page_controller.dart';
import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:app_code/view/screens/home_page_screen/screen/home_page_screen.dart';
import 'package:app_code/view/screens/intro_page_screen/screen/intro_page_screen.dart';
import 'package:app_code/view/screens/shop_page_screen/screen/shop_page_screen.dart';
import 'package:app_code/view/screens/splash_page_screen/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(
    const UserPanelApp(),
  );
}

class UserPanelApp extends StatelessWidget {
  const UserPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CarousalSliderController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignInPageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationBarController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesUserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestUserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => EditPageController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.splashScreen: (context) => const SplashScreen(),
          Routes.introPageScreen: (context) => const IntroPageScreen(),
          // Routes.signInPageScreen: (context) => SignInPageScreen(),
          Routes.homePageScreen: (context) => HomePageScreen(),
          // Routes.detailPageScreen: (context) => const DetailPageScreen(),
          Routes.shopPageScreen: (context) => const ShopPageScreen(),
          Routes.salesPageScreen: (context) => const SalesUserComponet(),
        },
      ),
    );
  }
}
