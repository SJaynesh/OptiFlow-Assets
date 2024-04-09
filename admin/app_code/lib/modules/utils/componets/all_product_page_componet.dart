import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals/routes.dart';
import '../helpers/fcm_helper.dart';
import '../helpers/firebase_auth_helper.dart';

class AllProductPageComponet extends StatefulWidget {
  const AllProductPageComponet({super.key});

  @override
  State<AllProductPageComponet> createState() => _AllProductPageComponetState();
}

class _AllProductPageComponetState extends State<AllProductPageComponet> {
  String departmentName = "DAIRY & FROZEN";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: StreamBuilder(
          stream: FCMHelper.fcmHelper.getAdminData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
              Map<String, dynamic> userData = data!.data() ?? {};
              return Text(
                "${userData["Company Name"]}",
                style: TextStyle(
                  fontSize: textScaler.scale(20),
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return Container();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: textScaler.scale(25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        fontSize: textScaler.scale(18),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          SizedBox(
                            width: h * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FireBaseAuthHelper.firebaseAuth.signOut();
                              exit(0);
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
            },
            child: Image.asset(
              "assets/images/splash_images/splash_image.png",
              height: h * 0.03,
            ),
          ),
          SizedBox(
            width: w * 0.04,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(h * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Department",
              style: TextStyle(
                fontSize: textScaler.scale(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: h * 0.07,
              width: w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w * 0.03),
                color: Colors.grey.withOpacity(0.3),
              ),
              padding: EdgeInsets.all(h * 0.01),
              child: DropdownButton(
                style: const TextStyle(
                  color: Colors.grey,
                ),
                // value: provider.departmentPageModel.department,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: const Text(
                  "Department",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isExpanded: true,
                items: departmentList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        onTap: () {
                          departmentName = e;
                          setState(() {});
                        },
                        child: Text(e),
                      ),
                    )
                    .toList(),

                onChanged: (value) {
                  // provider.getDepartmentPageData(department: value as String);
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FCMHelper.fcmHelper
                    .getAllProducts(department: departmentName),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR : ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    DocumentSnapshot<Map<String, dynamic>>? data =
                        snapshot.data;

                    Map<String, dynamic> products = data?.data() ?? {};
                    log("$products");
                    List productsList = products[departmentName] ?? [];
                    return (productsList.isNotEmpty)
                        ? ListView.separated(
                            itemBuilder: (context, index) {
                              Map<String, dynamic> product =
                                  productsList[index];
                              return ExpansionTile(
                                leading: Image.network(product['image']),
                                title: Text(
                                  product['title'],
                                  style: TextStyle(
                                    fontSize: textScaler.scale(20),
                                  ),
                                ),
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "DELETE",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: productsList.length)
                        : Center(
                            child: Text(
                            "No Data",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: textScaler.scale(25),
                            ),
                          ));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
