import 'package:app_code/modules/utils/componets/add_user_page_componet.dart';
import 'package:app_code/modules/utils/componets/department_page_componet.dart';
import 'package:app_code/modules/utils/componets/home_page_screen_componet.dart';
import 'package:app_code/modules/utils/componets/request_page_componet.dart';
import 'package:app_code/modules/utils/models/bottom_navigation_bar_model.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarController extends ChangeNotifier {
  BottomNavigationBarModel barModel = BottomNavigationBarModel(
    index: 0,
    componet: [
      const HomePageComponet(),
      DepartmentPageComponet(),
      const RequestPageComponet(),
      AddUserPageComponet(),
    ],
    isAnimated: false,
  );

  BottomNavigationBarController() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        barModel.isAnimated = !barModel.isAnimated;
        notifyListeners();
      },
    );
  }

  void getNavigationBarIndexValue({required int val}) {
    barModel.index = val;
    notifyListeners();
  }
}
