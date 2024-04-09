import 'package:flutter/material.dart';

class OrganizationPageModel {
  String countryValue;
  TextEditingController companyNameController;
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  TextEditingController inventoryDateController;

  OrganizationPageModel({
    required this.countryValue,
    required this.companyNameController,
    required this.fullNameController,
    required this.phoneNumberController,
    required this.inventoryDateController,
  });
}

class OrganizationPageDataGetModel {
  String companyName;
  String businessLocation;
  String fullName;
  String emailId;
  String password;
  String phoneNumber;
  String inventoryStartDate;

  OrganizationPageDataGetModel({
    required this.companyName,
    required this.businessLocation,
    required this.fullName,
    required this.emailId,
    required this.password,
    required this.phoneNumber,
    required this.inventoryStartDate,
  });

  Map<String, dynamic> toMap() => {
        'Company Name': companyName,
        'Full Name': fullName,
        'Email Id': emailId,
        'Password': password,
        'Phone Number': phoneNumber,
        'Business Location': businessLocation,
        'Inventory Start Date': inventoryStartDate,
      };
}
