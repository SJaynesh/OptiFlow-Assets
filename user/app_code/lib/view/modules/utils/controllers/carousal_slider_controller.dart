import 'package:flutter/material.dart';

import '../models/carousel_slider_model.dart';

class CarousalSliderController extends ChangeNotifier {
  CarousalSliderModel carousalSliderModel = CarousalSliderModel(index: 0);

  void getCarousalSliderValue({required int index}) {
    carousalSliderModel.index = index;
    notifyListeners();
  }
}
