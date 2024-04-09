import 'dart:async';
import 'dart:developer';

import 'package:app_code/view/modules/utils/helpers/firebase_auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

String userDeptName = "";
String adminEmail = "";

class FCMHelper {
  FCMHelper._();

  static final FCMHelper fcmHelper = FCMHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String collectionName = "Inventory-Management";

  String departmentCollection = "Department";
  String requestCollection = "Request";
  String userCollection = "Users";
  // String categotyDocName = "DAIRY & FROZEN";

  String summary = "Summary";
  String history = "History";

  Future<DocumentSnapshot<Map<String, dynamic>>> getAdminData() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await firestore.collection(collectionName).get();

    return await firestore.collection(collectionName).doc(adminEmail).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDepartmentData() {
    return firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .snapshots();
  }

  Future<void> updateTheQTYProduct(
      {required String title, required int qty, required double price}) async {
    DocumentSnapshot<Map<String, dynamic>> data = await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .get();

    Map<String, dynamic> mapData = data.data() ?? {};

    List productData = mapData[userDeptName];

    productData.forEach((e) async {
      if (e['title'] == title) {
        e['qty'] = e['qty'] - qty;
      }
    });

    await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .set({userDeptName: productData});

    DocumentSnapshot<Map<String, dynamic>> data2 = await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .collection(summary)
        .doc("summary")
        .get();

    Map<String, dynamic> summaryData = data2.data() ?? {};

    int sales = summaryData['sales'];
    double earning = double.parse(summaryData['earning'].toString());

    sales += qty;
    double total = price * qty;
    earning += total;

    await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .collection(summary)
        .doc("summary")
        .update({
      'sales': sales,
      'earning': earning,
    });

    DocumentSnapshot<Map<String, dynamic>> adminSummary = await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection("Summary")
        .doc("summary")
        .get();

    Map<String, dynamic> adminSummaryData = adminSummary.data() ?? {};
    int adminSales = adminSummaryData['sales'];
    double adminEarning = double.parse(adminSummaryData['earning'].toString());

    adminSales += sales;
    adminEarning += earning;

    await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection("Summary")
        .doc("summary")
        .update({
      'sales': sales,
      'earning': earning,
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEarningAndSales() {
    return firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .collection(summary)
        .doc("summary")
        .snapshots();
  }

  Future<void> setProductHistory(
      {required String title,
      required int qty,
      required String date,
      required String category}) async {
    await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .collection(history)
        .add({
      'title': title,
      'qty': qty,
      'date': date,
      'category': category,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductHistory() {
    return firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(departmentCollection)
        .doc(userDeptName)
        .collection(history)
        .snapshots();
  }

  Future<void> sendRequestProduct({
    required String category,
    required String product,
    required String date,
    required int qty,
  }) async {
    Map<String, dynamic> requestData = {
      'category': category,
      'product': product,
      'date': date,
      'qty': qty,
    };
    await firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(requestCollection)
        .doc(date)
        .set(requestData);
  }

  // Future<void> setUserData({
  //   required File profileImage,
  //   required File bgImage,
  //   required String fullName,
  //   required String userName,
  //   required String bio,
  //   required String phoneNumber,
  //   required String dob,
  //   required String gender,
  //   required String email,
  //   required String department,
  //   required String companyName,
  //   required String location,
  // }) async {
  //   // String fileName = "${profilePageModel.userName}.jpg";
  //   // Reference reference = storage.ref(fileName);
  //   var profileReference = await storage
  //       .ref()
  //       .child("$userName/profile.jpg")
  //       .putFile(profileImage);
  //
  //   var bgReference =
  //       await storage.ref().child("$userName/bgImage.jpg").putFile(bgImage);
  //
  //   firestore
  //       .collection(collectionName)
  //       .doc(documentName)
  //       .collection(userCollection)
  //       .doc(email)
  //       .set({
  //     'fullName': fullName,
  //     'userName': userName,
  //     'bio': bio,
  //     'phoneNumber': phoneNumber,
  //     'dob': dob,
  //     'email': email,
  //     'gender': gender,
  //     'department': department,
  //     'companyName': companyName,
  //     'location': location,
  //     'profileImage': await profileReference.ref.getDownloadURL(),
  //     'bgImage': await bgReference.ref.getDownloadURL(),
  //   });
  // }

  Future<void> updateProfileData({
    required var profileImage,
    required var bgImage,
    required String fullName,
    required String userName,
    required String bio,
    required String phoneNumber,
    required String dob,
    required String gender,
    // required String department,
    // required String companyName,
    // required String location,
  }) async {
    // String fileName = "${profilePageModel.userName}.jpg";
    // Reference reference = storage.ref(fileName);
    var profileReference;
    var bgReference;
    log("Image Value : $profileImage and $bgImage");
    if (profileImage is! String) {
      log("Profile Image If Else is Running");
      profileReference = await storage
          .ref()
          .child("$userName/profile.jpg")
          .putFile(profileImage);
    }
    if (bgImage is! String) {
      log("Bg Image If Else is Running");
      bgReference =
          await storage.ref().child("$userName/bgImage.jpg").putFile(bgImage);
    }

    String email = FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;

    firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(userCollection)
        .doc(email)
        .update({
      'fullName': fullName,
      'userName': userName,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'email': email,
      'gender': gender,
      // 'department': department,
      // 'companyName': companyName,
      // 'location': location,
      'profileImage': (profileImage is! String)
          ? await profileReference.ref.getDownloadURL()
          : profileImage,
      'bgImage': (bgImage is! String)
          ? await bgReference.ref.getDownloadURL()
          : bgImage,
    }).then((value) {
      log("With Null Image Updated Successfully");
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserProfileData() {
    String email = FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;

    log(email);
    return firestore
        .collection(collectionName)
        .doc(adminEmail)
        .collection(userCollection)
        .doc(email)
        .snapshots();
  }

  Future<void> getAdminEmailID() async {
    QuerySnapshot<Map<String, dynamic>> data =
        await firestore.collection(collectionName).get();

    List<DocumentSnapshot<Map<String, dynamic>>> docs = data.docs;

    adminEmail = docs[1].id;
    log("ADMIN EMAIL : $adminEmail");
  }

  // void updateProfileData({required ProfilePageModel profilePageModel}) async {
  //   String email = FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;
  //   await firestore
  //       .collection(collectionName)
  //       .doc(documentName)
  //       .collection(userCollection)
  //       .doc(email)
  //       .update(
  //         profilePageModel.toMap(),
  //       );
  // }
}
