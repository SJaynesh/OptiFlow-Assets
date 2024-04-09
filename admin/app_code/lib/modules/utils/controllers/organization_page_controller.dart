import 'package:app_code/modules/utils/models/organization_page_model.dart';
import 'package:flutter/material.dart';

class OrganizationPageController extends ChangeNotifier {
  OrganizationPageModel organizationPageModel = OrganizationPageModel(
    countryValue: "",
    companyNameController: TextEditingController(),
    fullNameController: TextEditingController(),
    phoneNumberController: TextEditingController(),
    inventoryDateController: TextEditingController(
      text:
          "${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().year}",
    ),
  );

  void getCountryData({required String country}) {
    organizationPageModel.countryValue = country;
    notifyListeners();
  }

  void getDateValue({required String formattedDate}) {
    organizationPageModel.inventoryDateController.text = formattedDate;
    notifyListeners();
  }

  void storeDataForSignUpData({
    required String companyName,
    required String fullName,
    required String phoneNumber,
  }) {
    organizationPageModel.companyNameController.text = companyName;
    organizationPageModel.fullNameController.text = fullName;
    organizationPageModel.phoneNumberController.text = phoneNumber;

    notifyListeners();
  }
}
