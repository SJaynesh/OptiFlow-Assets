import 'dart:developer';
import 'package:app_code/modules/utils/controllers/organization_page_controller.dart';
import 'package:app_code/modules/utils/controllers/sign_up_page_controller.dart';
import 'package:app_code/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:app_code/modules/utils/models/sign_up_page_model.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../../../modules/utils/globals/routes.dart';

class SignUpPageScreen extends StatelessWidget {
  SignUpPageScreen({super.key});

  GlobalKey<FormState> sign_up_form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var providerFalse =
    Provider.of<SignUpPageController>(context, listen: false);
    var providerTrue = Provider.of<SignUpPageController>(context, listen: true);
    var provideFalse2 = Provider.of<OrganizationPageController>(
        context, listen: false);

    Size size = MediaQuery
        .of(context)
        .size;
    TextScaler textScale = MediaQuery
        .of(context)
        .textScaler;
    double h = size.height;
    double w = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff000000),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(h * 0.025),
            child: Form(
              key: sign_up_form_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: Text(
                      "OptiFlow Assets Management",
                      style: GoogleFonts.moiraiOne(
                        textStyle: TextStyle(
                          fontSize: textScale.scale(20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffD7EDE9),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  const Text(
                    "Company Name",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                    child: TextFormField(
                      controller:
                      providerTrue.signUpPageModel.companyNameController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      validator: (val) =>
                      val!.isEmpty
                          ? "Please enter your organization name"
                          : null,
                      style: const TextStyle(
                        color: Color(0xffE6E8FA),
                      ),
                      cursorColor: const Color(0xffE6E8FA),
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.apartment_sharp,
                          color: (providerTrue
                              .signUpPageModel.companyNameController.text !=
                              "")
                              ? const Color(0xffE6E8FA)
                              : Colors.blueGrey,
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Full Name",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                    child: TextFormField(
                      controller: providerTrue.signUpPageModel.fullNameController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        color: Color(0xffE6E8FA),
                      ),
                      cursorColor: const Color(0xffE6E8FA),
                      validator: (val) =>
                      val!.isEmpty ? "Please enter your name" : null,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.keyboard,
                          color: (providerTrue
                              .signUpPageModel.fullNameController.text !=
                              "")
                              ? const Color(0xffE6E8FA)
                              : Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Email Address",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.04,
                    child: TextFormField(
                      controller:
                      providerTrue.signUpPageModel.emailAddressController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color(0xffE6E8FA),
                      ),
                      cursorColor: const Color(0xffE6E8FA),
                      validator: (val) =>
                      val!.isEmpty
                          ? "Please enter a valid email address"
                          : null,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: (providerTrue.signUpPageModel
                              .emailAddressController.text !=
                              "")
                              ? const Color(0xffE6E8FA)
                              : Colors.blueGrey,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: h * 0.04,
                          child: TextFormField(
                            obscureText: providerTrue.signUpPageModel.showPassword,
                            obscuringCharacter: "*",
                            controller:
                            providerTrue.signUpPageModel.passwordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            validator: (val) =>
                            val!.isEmpty
                                ? "Password cannot be less than 8 characters"
                                : null,
                            style: const TextStyle(
                              color: Color(0xffE6E8FA),
                            ),
                            onChanged: (password) {
                              providerFalse.getPasswordData(password: password);
                            },
                            cursorColor: const Color(0xffE6E8FA),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  (providerTrue.signUpPageModel.showPassword)
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: (providerTrue.signUpPageModel
                                      .passwordController.text !=
                                      "")
                                      ? const Color(0xffE6E8FA)
                                      : Colors.blueGrey,
                                ),
                                onPressed: () {
                                  providerFalse.changePasswordVisibled();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                          visible: (providerTrue
                              .signUpPageModel.passwordController.text !=
                              "")
                              ? true
                              : false,
                          child: LinearProgressIndicator(
                            color: (providerTrue.signUpPageModel.passwordController
                                .text.length >= 1 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <=
                                    3)
                                ? Colors.redAccent
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 4 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <=
                                    5)
                                ? Colors.yellowAccent
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 6 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    7)
                                ? Colors.yellowAccent
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 8 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    9)
                                ? Colors.green.shade300
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 10 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    12)
                                ? Colors.green
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 13 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <= 18)
                                ? Colors.green
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 19)
                                ? Colors.green
                                : Colors.transparent,
                            minHeight: 15,
                            value: (providerTrue.signUpPageModel.passwordController
                                .text.length >= 1 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <=
                                    3)
                                ? 0.2
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 4 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <=
                                    5)
                                ? 0.43
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 6 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    7)
                                ? 0.55
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 8 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    9)
                                ? 0.65
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 10 &&
                                providerTrue
                                    .signUpPageModel
                                    .passwordController
                                    .text
                                    .length <=
                                    12)
                                ? 0.8
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 13 &&
                                providerTrue.signUpPageModel.passwordController.text
                                    .length <= 18)
                                ? 0.9
                                : (providerTrue.signUpPageModel.passwordController
                                .text.length >= 19)
                                ? 1
                                : 0,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.065,
                    child: IntlPhoneField(
                      // controller: companyNameController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: Color(0xffE6E8FA),
                      ),
                      initialCountryCode: 'IN',
                      decoration: const InputDecoration(
                        prefixStyle: TextStyle(
                          color: Colors.white,
                        ),
                        prefixIconColor: Colors.white,
                      ),
                      controller:
                      providerTrue.signUpPageModel.phoneNumberController,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Choose Country/Region",
                    style: TextStyle(
                      color: Color(0xffDBE9F4),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  CSCPicker(
                    flagState: CountryFlag.DISABLE,
                    dropdownDecoration: const BoxDecoration(
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    dropdownHeadingStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2C2C2B),
                    ),
                    showCities: false,
                    showStates: false,
                    searchBarRadius: textScale.scale(10),
                    defaultCountry: CscCountry.India,
                    countryDropdownLabel: providerTrue.signUpPageModel.countryValue,
                    selectedItemStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    onCountryChanged: (country) {
                      providerFalse.getCountryData(country: country);
                    },
                  ),
                  const Spacer(),
                  Text(
                    "Your data will be in ${providerTrue.signUpPageModel
                        .countryValue.toUpperCase()} data center.",
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        focusColor: Colors.white,
                        activeColor: Colors.blue,
                        value: providerTrue.signUpPageModel.check,
                        onChanged: (checked) {
                          providerFalse.getCheckBoxData(checked: checked ?? false);
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            "By clicking 'Create Account', you agree to",
                            style: GoogleFonts.robotoSlab(
                              textStyle: TextStyle(
                                fontSize: textScale.scale(13),
                                color: const Color(0xffE6E8FA),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "the",
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: textScale.scale(13),
                                    color: const Color(0xffE6E8FA),
                                  ),
                                ),
                              ),
                              Text(
                                " Terms of Service",
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: textScale.scale(13),
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Text(
                                " and",
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: textScale.scale(13),
                                    color: const Color(0xffE6E8FA),
                                  ),
                                ),
                              ),
                              Text(
                                " Privacy Policy.",
                                style: GoogleFonts.robotoSlab(
                                  textStyle: TextStyle(
                                    fontSize: textScale.scale(13),
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: providerTrue.signUpPageModel.termsAndCondition,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please read and accept the Terms of Service and",
                          style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                              fontSize: textScale.scale(12),
                              color: const Color(0xffc12e2e),
                            ),
                          ),
                        ),
                        Text(
                          " Privacy Policy",
                          style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                              fontSize: textScale.scale(12),
                              color: const Color(0xffc12e2e),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Theme(
                      data: ThemeData(
                        useMaterial3: false,
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (providerTrue.signUpPageModel.check) {
                            providerFalse.changeVisibilityTermsAndConditionLine(
                                getTerms: false);
                            if (sign_up_form_key.currentState!.validate()) {
                              String companyName = providerTrue
                                  .signUpPageModel.companyNameController.text;
                              String fullName = providerTrue
                                  .signUpPageModel.fullNameController.text;
                              String emailAddress = providerTrue
                                  .signUpPageModel.emailAddressController.text
                                  .trim();
                              String password = providerTrue
                                  .signUpPageModel.passwordController.text
                                  .trim();
                              String phoneNumber = providerTrue
                                  .signUpPageModel.phoneNumberController.text;
                              String selectedCountry =
                                  providerTrue.signUpPageModel.countryValue;

                              SignUpPageDataGetModel allSignUpData =
                              SignUpPageDataGetModel(
                                companyName: companyName,
                                fullName: fullName,
                                emailAddress: emailAddress,
                                password: password,
                                phoneNumber: phoneNumber,
                                selectedCountry: selectedCountry,
                              );

                              Map<String, dynamic> res = await FireBaseAuthHelper
                                  .firebaseAuth
                                  .signUpWithEmailAddress(
                                email: allSignUpData.emailAddress,
                                password: allSignUpData.password,
                              );

                              if (res['error'] != null) {
                                providerFalse.changeCircularVisiblity();
                                Future.delayed(
                                  const Duration(seconds: 5),
                                      () {
                                    providerFalse.changeCircularVisiblity();
                                    SnackBar snackBar = SnackBar(
                                      content:
                                      Text("ERROR : ${res['error']}"),
                                      backgroundColor: Colors.redAccent,
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                );
                              }

                              if (res['user'] != null) {
                                // Navigator.pop(context);
                                if (context.mounted) {
                                  providerFalse.changeCircularVisiblity();
                                  Future.delayed(
                                    const Duration(seconds: 5),
                                        () {
                                          provideFalse2.storeDataForSignUpData(
                                            companyName: allSignUpData.companyName,
                                            fullName: allSignUpData.fullName,
                                            phoneNumber: allSignUpData.phoneNumber,);
                                      providerFalse.changeCircularVisiblity(); 
                                    },
                                  );

                                }
                              }

                              await FireBaseAuthHelper.firebaseAuth.firebase
                                  .verifyPhoneNumber(
                                phoneNumber: "+91${allSignUpData.phoneNumber}",
                                verificationCompleted: (phoneAuthCredential) {

                                },
                                verificationFailed:(error) {
                                  if (error.code == 'invalid-phone-number') {
                                    log('The provided phone number is not valid .${error.code}');
                                    SnackBar snackBar = const SnackBar(
                                      content: Text(
                                          "Your Phone Number is Invalid. Please Check Number.🥲🥲🥲"),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    log("ERROR : ${error.code}");
                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                          "${error.code} This Resion Not Possible Phone Number Verification.😔😔😔"),
                                      backgroundColor: Colors.red,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                },
                                codeSent:(verificationId, forceResendingToken) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.phonePageScreen,
                                    arguments: {
                                      'email': allSignUpData.emailAddress,
                                      'password': allSignUpData.password,
                                      'verificationId' : verificationId,
                                    },
                                  );
                                },
                                codeAutoRetrievalTimeout: (verificationId) {
                                },
                              );

                              // await FireBaseAuthHelper
                              //     .firebaseAuth
                              //     .signInWithMobileOTP(
                              //   phoneNumber: allSignUpData.phoneNumber,
                              //   context: context,
                              // );
                            }
                          } else {
                            providerFalse.changeVisibilityTermsAndConditionLine(
                                getTerms: true);
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(15),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                textScale.scale(5),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          "Create Account".toUpperCase(),
                          style: GoogleFonts.robotoSlab(
                            textStyle: TextStyle(
                              fontSize: textScale.scale(16),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffE6E8FA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: providerTrue.signUpPageModel.circularVisibled,
            child: Container(
              height: h,
              width: w,
              color: Colors.black.withOpacity(0.4),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ),
        ]
      ),
    );
  }
}
