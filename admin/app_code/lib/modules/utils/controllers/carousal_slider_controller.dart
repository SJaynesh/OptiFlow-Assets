import 'package:app_code/modules/utils/models/carousel_slider_model.dart';
import 'package:flutter/material.dart';

class CarousalSliderController extends ChangeNotifier {
  CarousalSliderModel carousalSliderModel = CarousalSliderModel(index: 0);

  void getCarousalSliderValue({required int index}) {
    carousalSliderModel.index = index;
    notifyListeners();
  }
}
