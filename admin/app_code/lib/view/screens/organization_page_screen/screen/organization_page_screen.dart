import 'dart:developer';

import 'package:app_code/modules/utils/controllers/organization_page_controller.dart';
import 'package:app_code/modules/utils/globals/routes.dart';
import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/modules/utils/models/organization_page_model.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class OrganizationPageScreen extends StatelessWidget {
  OrganizationPageScreen({super.key});

  GlobalKey<FormState> organization_page_form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    var providerTrue = Provider.of<OrganizationPageController>(context);
    var providerFalse =
        Provider.of<OrganizationPageController>(context, listen: false);

    Map data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfff4f4f4),
        title: Text(
          "Let's setup your organization",
          style: TextStyle(
            fontSize: textScaler.scale(20),
            color: const Color(0xff1e2736),
          ),
        ),
        actions: [
          const Icon(
            Icons.headset_mic,
            color: Color(0xff1e2736),
          ),
          SizedBox(
            width: w * 0.05,
          ),
          const Icon(
            Icons.more_vert,
            color: Color(0xff1e2736),
          ),
          SizedBox(
            width: w * 0.025,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(textScaler.scale(15)),
        child: Stack(
          children: [
            Container(
              height: h * 0.6,
              width: w,
              padding: EdgeInsets.all(textScaler.scale(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 3,
                    color: Colors.grey.withOpacity(0.6),
                  )
                ],
              ),
              child: Form(
                key: organization_page_form_key,
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.apartment_outlined,
                          color: Colors.grey,
                        ),
                        const Spacer(),
                        Text(
                          "Company Name ",
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6AABDA),
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                      child: TextFormField(
                        controller: providerTrue
                            .organizationPageModel.companyNameController,
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter company name" : null,
                        cursorColor: const Color(0xff6AABDA),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        const Spacer(),
                        Text(
                          "Business Location ",
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6AABDA),
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.8,
                      child: CSCPicker(
                        flagState: CountryFlag.DISABLE,
                        dropdownDecoration: BoxDecoration(
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        dropdownHeadingStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2C2C2B),
                        ),
                        showCities: false,
                        showStates: false,
                        searchBarRadius: textScaler.scale(10),
                        defaultCountry: CscCountry.India,
                        countryDropdownLabel:
                            providerTrue.organizationPageModel.countryValue,
                        selectedItemStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                        onCountryChanged: (country) {
                          providerFalse.getCountryData(country: country);
                        },
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        const Spacer(),
                        Text(
                          "Full Name ",
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6AABDA),
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.03,
                      child: TextFormField(
                        controller: providerTrue
                            .organizationPageModel.fullNameController,
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter full name" : null,
                        cursorColor: const Color(0xff6AABDA),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.call,
                          color: Colors.grey,
                        ),
                        const Spacer(),
                        Text(
                          "Phone Number ",
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6AABDA),
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.065,
                      child: IntlPhoneField(
                        controller: providerTrue
                            .organizationPageModel.phoneNumberController,
                        validator: (val) =>
                            (val != null) ? null : "Enter valid number",
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          height: 2,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        // controller:
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_sharp,
                          color: Colors.grey,
                        ),
                        const Spacer(),
                        Text(
                          "Inventory Start Date ",
                          style: TextStyle(
                            fontSize: textScaler.scale(18),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6AABDA),
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            controller: providerTrue
                                .organizationPageModel.inventoryDateController,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff072942),
                            ),
                            enabled: false,
                            cursorColor: const Color(0xff6AABDA),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              log("Date Picker");
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                log("$pickedDate");
                                String formattedDate =
                                    DateFormat('MM/dd/yyyy').format(pickedDate);

                                providerFalse.getDateValue(
                                    formattedDate: formattedDate);
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(textScaler.scale(12)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: ThemeData(
                    useMaterial3: false,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (organization_page_form_key.currentState!.validate()) {
                        String companyName = providerTrue
                            .organizationPageModel.companyNameController.text;
                        String businessLocation =
                            providerTrue.organizationPageModel.countryValue;
                        String fullName = providerTrue
                            .organizationPageModel.fullNameController.text;
                        String phoneNumber = providerTrue
                            .organizationPageModel.phoneNumberController.text;
                        String inventoryStartDate = providerTrue
                            .organizationPageModel.inventoryDateController.text;

                        OrganizationPageDataGetModel organizationData =
                            OrganizationPageDataGetModel(
                          companyName: companyName,
                          businessLocation: businessLocation,
                          fullName: fullName,
                          emailId: data['email'],
                          password: data['password'],
                          phoneNumber: phoneNumber,
                          inventoryStartDate: inventoryStartDate,
                        );

                        log(organizationData.companyName);
                        log(organizationData.businessLocation);
                        log(organizationData.fullName);
                        log(organizationData.phoneNumber);
                        log(organizationData.inventoryStartDate);
                        log(organizationData.emailId);

                        await FCMHelper.fcmHelper
                            .storeUserInformationData(
                                userData: organizationData)
                            .then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.homePageScreen, (route) => false);
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xff072942),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            textScaler.scale(10),
                          ),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(
                          left: textScaler.scale(35),
                          right: textScaler.scale(35),
                          top: textScaler.scale(10),
                          bottom: textScaler.scale(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: textScaler.scale(18),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
