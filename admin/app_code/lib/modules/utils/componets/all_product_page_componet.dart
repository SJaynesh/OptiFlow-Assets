import 'dart:developer';
import 'dart:io';

import 'package:app_code/modules/utils/models/all_product_page_model.dart';
import 'package:app_code/view/screens/chat_page_screen/screen/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/add_product_page_controller.dart';
import '../globals/routes.dart';
import '../helpers/fcm_helper.dart';
import '../helpers/firebase_auth_helper.dart';

class AllProductPageComponet extends StatelessWidget {
  AllProductPageComponet({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    Future.delayed(const Duration(seconds: 6), () {
      Provider.of<AllProductPageController>(context, listen: false)
          .changeShimmer();
    });
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
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ChatPage(),
                  transitionDuration: const Duration(seconds: 1),
                  reverseTransitionDuration: const Duration(seconds: 1),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.chat),
          ),
          SizedBox(
            width: w * 0.04,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(h * 0.02),
        child: (!Provider.of<AllProductPageController>(context).isShimmer)
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: h * 0.055,
                      width: w * 0.4,
                      color: Colors.grey[300],
                    ),
                    SizedBox(
                      height: h * 0.02,
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
                        items: const [],

                        onChanged: (value) {
                          Provider.of<AllProductPageController>(context,
                                  listen: false)
                              .addProduct(val: value.toString());
                        },
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FCMHelper.fcmHelper.getAllProducts(
                            department: Provider.of<AllProductPageController>(
                                    context,
                                    listen: true)
                                .addProductPageModel
                                .department),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("ERROR : ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData) {
                            DocumentSnapshot<Map<String, dynamic>>? data =
                                snapshot.data;

                            Map<String, dynamic> products = data?.data() ?? {};
                            List productsList = products[
                                    Provider.of<AllProductPageController>(
                                            context,
                                            listen: true)
                                        .addProductPageModel
                                        .department] ??
                                [];
                            return (productsList.isNotEmpty)
                                ? ListView.separated(
                                    padding: EdgeInsets.only(
                                      top: h * 0.025,
                                      bottom: h * 0.02,
                                    ),
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> product =
                                          productsList[index];
                                      return ExpansionTile(
                                        leading: Container(
                                          height: h * 0.1,
                                          width: w * 0.18,
                                          color: Colors.grey[300],
                                        ),
                                        title: Container(
                                          height: h * 0.025,
                                          margin: EdgeInsets.only(
                                            right: w * 0.08,
                                          ),
                                          // width: w * 0.01,
                                          color: Colors.grey[300],
                                        ),
                                        subtitle: Container(
                                          height: h * 0.022,
                                          margin: EdgeInsets.only(
                                            top: h * 0.01,
                                            right: w * 0.2,
                                          ),
                                          // width: w * 0.01,
                                          color: Colors.grey[300],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemCount: productsList.length)
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/add_product_page_image/history.png",
                                          height: h * 0.2,
                                        ),
                                        Text(
                                          "No Any Data Found",
                                          style: TextStyle(
                                            fontSize: textScaler.scale(20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Department",
                    style: TextStyle(
                      fontSize: textScaler.scale(25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
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
                      value: Provider.of<AllProductPageController>(context,
                              listen: true)
                          .addProductPageModel
                          .department,
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
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (value) {
                        Provider.of<AllProductPageController>(context,
                                listen: false)
                            .addProduct(val: value.toString());
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FCMHelper.fcmHelper.getAllProducts(
                          department: Provider.of<AllProductPageController>(
                                  context,
                                  listen: true)
                              .addProductPageModel
                              .department),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("ERROR : ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                          DocumentSnapshot<Map<String, dynamic>>? data =
                              snapshot.data;

                          Map<String, dynamic> products = data?.data() ?? {};
                          List productsList = products[
                                  Provider.of<AllProductPageController>(context,
                                          listen: true)
                                      .addProductPageModel
                                      .department] ??
                              [];
                          return (productsList.isNotEmpty)
                              ? ListView.separated(
                                  padding: EdgeInsets.only(
                                    top: h * 0.025,
                                    bottom: h * 0.02,
                                  ),
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> product =
                                        productsList[index];
                                    return ExpansionTile(
                                      leading: Transform.scale(
                                        scale: 1.3,
                                        child: Image.network(
                                          product['image'],
                                        ),
                                      ),
                                      title: Text(
                                        product['title'],
                                        style: TextStyle(
                                          fontSize: textScaler.scale(20),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        product['department'],
                                        style: TextStyle(
                                          fontSize: textScaler.scale(15),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(h * 0.01),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(product['description']),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "PRICE : ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                      "Rs. ${product['price']}"),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "QTY : ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text("Rs. ${product['qty']}"),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Update",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    textScaler
                                                                        .scale(
                                                                            20),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                            content: Form(
                                                              key: formKey,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    TextFormField(
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "Title",
                                                                      ),
                                                                      initialValue:
                                                                          product[
                                                                              'title'],
                                                                      validator: (val) => val!
                                                                              .isEmpty
                                                                          ? "Enter title..."
                                                                          : null,
                                                                      onSaved:
                                                                          (val) {
                                                                        Provider.of<AllProductPageController>(context, listen: false).getTitle(
                                                                            val:
                                                                                val ?? "");
                                                                      },
                                                                    ),
                                                                    TextFormField(
                                                                      maxLines:
                                                                          3,
                                                                      initialValue:
                                                                          product[
                                                                              'description'],
                                                                      validator: (val) => val!
                                                                              .isEmpty
                                                                          ? "Enter description..."
                                                                          : null,
                                                                      onSaved:
                                                                          (val) {
                                                                        Provider.of<AllProductPageController>(context, listen: false).getDescription(
                                                                            val:
                                                                                val ?? "");
                                                                      },
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "Description",
                                                                      ),
                                                                    ),
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      initialValue:
                                                                          "${product['price']}",
                                                                      validator: (val) => val!
                                                                              .isEmpty
                                                                          ? "Enter price..."
                                                                          : null,
                                                                      onSaved:
                                                                          (val) {
                                                                        Provider.of<AllProductPageController>(context, listen: false).getPrice(
                                                                            val:
                                                                                int.parse(val ?? "0"));
                                                                      },
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "Price",
                                                                      ),
                                                                    ),
                                                                    TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      initialValue:
                                                                          "${product['qty']}",
                                                                      validator: (val) => val!
                                                                              .isEmpty
                                                                          ? "Enter qty..."
                                                                          : null,
                                                                      onSaved:
                                                                          (val) {
                                                                        Provider.of<AllProductPageController>(context, listen: false).getQty(
                                                                            val:
                                                                                int.parse(val ?? "0"));
                                                                      },
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            "Qty",
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: h *
                                                                          0.02,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        TextButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            if (formKey.currentState!.validate()) {
                                                                              formKey.currentState!.save();
                                                                              String department = Provider.of<AllProductPageController>(context, listen: false).addProductPageModel.department;
                                                                              String title = Provider.of<AllProductPageController>(context, listen: false).addProductPageModel.title;
                                                                              String description = Provider.of<AllProductPageController>(context, listen: false).addProductPageModel.description;
                                                                              int price = Provider.of<AllProductPageController>(context, listen: false).addProductPageModel.price;
                                                                              int qty = Provider.of<AllProductPageController>(context, listen: false).addProductPageModel.qty;

                                                                              AllProductPageModel allProductPageModel = AllProductPageModel(
                                                                                department: department,
                                                                                title: title,
                                                                                description: description,
                                                                                price: price,
                                                                                qty: qty,
                                                                              );

                                                                              FCMHelper.fcmHelper
                                                                                  .editProduct(
                                                                                allProductPageModel: allProductPageModel,
                                                                                title: product['title'],
                                                                              )
                                                                                  .then((value) {
                                                                                Navigator.pop(context);
                                                                                SnackBar snackBar = SnackBar(
                                                                                  content: const Text("Data Update Successfully"),
                                                                                  backgroundColor: Colors.green,
                                                                                  dismissDirection: DismissDirection.horizontal,
                                                                                  behavior: SnackBarBehavior.floating,
                                                                                  margin: EdgeInsets.all(h * 0.02),
                                                                                );
                                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                              });
                                                                            }
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.edit,
                                                                          ),
                                                                          label:
                                                                              Text(
                                                                            "EDIT",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: textScaler.scale(
                                                                                20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                    ),
                                                    label: const Text(
                                                      "EDIT",
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "DELETE"),
                                                            content: const Text(
                                                                "Are you sure delete? "),
                                                            actions: [
                                                              TextButton.icon(
                                                                onPressed: () {
                                                                  FCMHelper
                                                                      .fcmHelper
                                                                      .deleteProduct(
                                                                    department: Provider.of<AllProductPageController>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .addProductPageModel
                                                                        .department,
                                                                    name: product[
                                                                        'title'],
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                label:
                                                                    const Text(
                                                                  "Delete",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                  ),
                                                                ),
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.redAccent,
                                                    ),
                                                    label: const Text(
                                                      "DELETE",
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: productsList.length)
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/add_product_page_image/history.png",
                                        height: h * 0.2,
                                      ),
                                      Text(
                                        "No Any Data Found",
                                        style: TextStyle(
                                          fontSize: textScaler.scale(20),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
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
