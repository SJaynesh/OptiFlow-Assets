import 'package:app_code/view/modules/utils/componets/home_page_componet.dart';
import 'package:app_code/view/modules/utils/componets/request_user_componet.dart';
import 'package:app_code/view/modules/utils/componets/sales_user_componet.dart';
import 'package:app_code/view/modules/utils/componets/setting_user_componet.dart';
import 'package:app_code/view/modules/utils/models/bottom_navaigation_bar_model.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarController extends ChangeNotifier {
  BottomNavigationBarModel navigationBarModel = BottomNavigationBarModel(
    index: 0,
    componets: [
      const HomePageComponet(),
      const SalesUserComponet(),
      RequestUserComponet(),
      const SettingUserComponet(),
    ],
    isAnimated: false,
  );

  BottomNavigationBarController() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        navigationBarModel.isAnimated = !navigationBarModel.isAnimated;
        notifyListeners();
      },
    );
  }

  void getNavigationBarIndexValue({required int val}) {
    navigationBarModel.index = val;
    notifyListeners();
  }
}
