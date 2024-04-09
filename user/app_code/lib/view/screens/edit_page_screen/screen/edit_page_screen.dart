import 'dart:developer';
import 'dart:io';

import 'package:app_code/view/modules/utils/controllers/edit_page_controller.dart';
import 'package:app_code/view/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/view/modules/utils/models/profile_page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPageScreen extends StatelessWidget {
  EditPageScreen({
    super.key,
  });

  GlobalKey<FormState> editPageKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.textScalerOf(context);
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return Consumer<EditPageController>(
      builder: (context, provider, _) {
        return StreamBuilder(
          stream: FCMHelper.fcmHelper.getUserProfileData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
              Map<String, dynamic> userData = data?.data() ?? {};
              ProfilePageModel profilePageModel =
                  ProfilePageModel.fromMap(userData);
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton.filledTonal(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_outlined),
                  ),
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: textScaler.scale(23),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        if (editPageKey.currentState!.validate()) {
                          editPageKey.currentState!.save();
                          log("Call The Helper Class");
                          FCMHelper.fcmHelper
                              .updateProfileData(
                            bgImage: provider.editPageModel.bgImage ??
                                profilePageModel.bgImage,
                            profileImage: provider.editPageModel.profileImage ??
                                profilePageModel.profileImage,
                            fullName: provider.editPageModel.fullName,
                            userName: provider.editPageModel.userName,
                            bio: provider.editPageModel.bio,
                            phoneNumber: provider.editPageModel.phoneNumber,
                            dob: provider.editPageModel.dobController.text,
                            gender: provider.editPageModel.gender,
                          )
                              .then((value) {
                            provider.assignNullValue();
                            Navigator.pop(context);
                          });
                          log("Call The End Helper Class");
                        }
                      },
                      child: const Text("Save"),
                    ),
                    SizedBox(width: w * 0.05),
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.only(top: h * 0.02),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: h * 0.25,
                            width: w,
                            color: Colors.white,
                          ),
                          Container(
                            height: h * 0.2,
                            width: w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (provider.editPageModel.bgImage != null)
                                    ? FileImage(
                                        provider.editPageModel.bgImage as File)
                                    : NetworkImage(
                                        profilePageModel.bgImage,
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            padding: EdgeInsets.all(h * 0.015),
                            alignment: Alignment.topRight,
                            child: IconButton.filled(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: h * 0.25,
                                      width: w,
                                      padding: EdgeInsets.only(left: w * 0.05),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: h * 0.01,
                                            width: w * 0.15,
                                            margin:
                                                EdgeInsets.only(top: h * 0.025),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.05),
                                            ),
                                          ),
                                          const Spacer(),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            onTap: () {
                                              provider.pickBgImage(
                                                image: ImageSource.camera,
                                              );
                                              Navigator.pop(context);
                                            },
                                            title: const Text(
                                              "View or edit profile photo",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.photo_size_select_actual,
                                            ),
                                            onTap: () {
                                              provider.pickBgImage(
                                                image: ImageSource.gallery,
                                              );
                                              Navigator.pop(context);
                                            },
                                            title: const Text(
                                              "Add frame",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                              ),
                              icon: const Icon(Icons.edit),
                              color: Colors.blueAccent,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: w * 0.035,
                              top: h * 0.1,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: w * 0.17,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: w * 0.16,
                                    backgroundImage:
                                        (provider.editPageModel.profileImage !=
                                                null)
                                            ? FileImage(provider.editPageModel
                                                .profileImage as File)
                                            : NetworkImage(
                                                profilePageModel.profileImage,
                                              ) as ImageProvider,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: w * 0.06,
                                  backgroundColor: Colors.white,
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: FloatingActionButton.small(
                                      backgroundColor: Colors.blue.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(w * 0.1),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: h * 0.25,
                                              width: w,
                                              padding: EdgeInsets.only(
                                                  left: w * 0.05),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: h * 0.01,
                                                    width: w * 0.15,
                                                    margin: EdgeInsets.only(
                                                        top: h * 0.025),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              w * 0.05),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.camera_alt),
                                                    onTap: () {
                                                      provider.pickProfileImage(
                                                        image:
                                                            ImageSource.camera,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    title: const Text(
                                                      "View or edit profile photo",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons
                                                          .photo_size_select_actual,
                                                    ),
                                                    onTap: () {
                                                      provider.pickProfileImage(
                                                        image:
                                                            ImageSource.gallery,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    title: const Text(
                                                      "Add frame",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: h * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: Form(
                          key: editPageKey,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: h * 0.025, right: h * 0.025),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.01),
                                    child: TextFormField(
                                      initialValue: profilePageModel.fullName,
                                      validator: (val) =>
                                          (val!.isEmpty) ? "Enter name" : null,
                                      onSaved: (val) {
                                        provider.editPageModel.fullName =
                                            val ?? "";
                                      },
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        label: Text("Name"),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.005),
                                    child: TextFormField(
                                      initialValue: profilePageModel.userName,
                                      textInputAction: TextInputAction.next,
                                      validator: (val) => (val!.isEmpty)
                                          ? "Enter user name"
                                          : null,
                                      onSaved: (val) {
                                        provider.editPageModel.userName =
                                            val ?? "";
                                      },
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        label: Text("Username"),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.005),
                                    child: TextFormField(
                                      initialValue: profilePageModel.bio,
                                      validator: (val) =>
                                          (val!.isEmpty) ? "Enter bio" : null,
                                      onSaved: (val) {
                                        provider.editPageModel.bio = val ?? "";
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        label: Text("Bio"),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.005),
                                    child: TextFormField(
                                      initialValue:
                                          profilePageModel.phoneNumber,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      validator: (val) => (val!.isEmpty)
                                          ? "Enter name"
                                          : (val.length < 10)
                                              ? "Enter valid number"
                                              : null,
                                      onSaved: (val) {
                                        provider.editPageModel.phoneNumber =
                                            val ?? "";
                                      },
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        label: Text("Phone Number"),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('MM-dd-yyyy')
                                                .format(pickedDate);

                                        provider.getDateOfBirthDay(
                                            date: formattedDate);

                                        // request.getDateValue(
                                        //     formattedDate: formattedDate);
                                        // sales.getDateValue(formattedDate: formattedDate);
                                      }
                                    },
                                    child: TextFormField(
                                      controller:
                                          provider.editPageModel.dobController,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      cursorColor: const Color(0xff6AABDA),
                                      validator: (val) => (val!.isEmpty)
                                          ? "Enter Date..."
                                          : null,
                                      decoration: const InputDecoration(
                                        label: Text("Birth Date"),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        enabled: false,
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.012),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Gender",
                                          style: TextStyle(
                                            fontSize: textScaler.scale(18),
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Radio(
                                          value: "Male",
                                          groupValue:
                                              provider.editPageModel.gender,
                                          onChanged: (val) {
                                            provider.getGenderValue(
                                                gender: val ?? "");
                                          },
                                        ),
                                        Text(
                                          "Male",
                                          style: TextStyle(
                                            fontSize: textScaler.scale(15),
                                          ),
                                        ),
                                        Radio(
                                          value: "Female",
                                          groupValue:
                                              provider.editPageModel.gender,
                                          onChanged: (val) {
                                            provider.getGenderValue(
                                                gender: val ?? "");
                                          },
                                        ),
                                        Text(
                                          "Female",
                                          style: TextStyle(
                                            fontSize: textScaler.scale(15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
