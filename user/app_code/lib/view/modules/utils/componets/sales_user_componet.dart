import 'dart:developer';

import 'package:app_code/view/modules/utils/controllers/product_controller.dart';
import 'package:app_code/view/modules/utils/controllers/sales_user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/fcm_helper.dart';

class SalesUserComponet extends StatelessWidget {
  const SalesUserComponet({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F2F2),
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: FutureBuilder(
          future: FCMHelper.fcmHelper.getAdminData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                "${snapshot.error}",
                style: TextStyle(
                  fontSize: textScaler.scale(23),
                  fontWeight: FontWeight.w800,
                ),
              );
            } else if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
              Map<String, dynamic> adminData = data?.data() ?? {};
              return Text(
                "${adminData['Company Name']}",
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
          CircleAvatar(
            radius: w * 0.07,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: w * 0.058,
              backgroundImage: const NetworkImage(
                  "https://avatars.githubusercontent.com/u/115562979?v=4"),
            ),
          ),
          SizedBox(
            width: w * 0.04,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Consumer<ProductController>(
          builder: (context, controller, child) {
            return Consumer<SalesUserController>(
              builder: (context, sales, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                            "assets/images/sales_page_images/sales.png"),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: w * 0.4,
                                  // color: Colors.red,
                                  child: (sales.salesUser.image.isEmpty)
                                      ? Container()
                                      : Image.network(
                                          sales.salesUser.image,
                                          height: h * 0.1,
                                        ),
                                ),
                              ],
                            ),
                            Text(
                              "Category ",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton(
                              value: sales.salesUser.category,
                              icon: const Icon(Icons.category),
                              hint: const Text("Select"),
                              alignment: Alignment.centerLeft,
                              borderRadius: BorderRadius.circular(20),
                              // elevation: 80,
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.green.shade100,
                              isExpanded: true,
                              items: controller.productModel.Categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                sales.getCategoryForDropDown(value: value);

                                showGeneralDialog(
                                  context: context,
                                  pageBuilder: (context, _, __) {
                                    return Scaffold(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.7),
                                      body: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "Select ${sales.salesUser.category}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        textScaler.scale(25),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    children:
                                                        controller.productModel
                                                            .Products
                                                            .map(
                                                              (e) => (e.category ==
                                                                      sales
                                                                          .salesUser
                                                                          .category)
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        sales
                                                                            .getProductData(
                                                                          category:
                                                                              e.category,
                                                                          title:
                                                                              e.title,
                                                                          price:
                                                                              e.price,
                                                                          image:
                                                                              e.image,
                                                                        );
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .primaries[Provider.of<ProductController>(context, listen: true).productModel.Products.indexOf(e) % 18]
                                                                              .withOpacity(0.25),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            4),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              e.title,
                                                                              style: TextStyle(fontSize: textScaler.scale(18), fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                            SizedBox(
                                                                              height: h * 0.01,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "₹${e.price}.00",
                                                                                  style: TextStyle(
                                                                                    fontSize: textScaler.scale(18),
                                                                                    fontWeight: FontWeight.w900,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "${e.qty} Qty",
                                                                                  style: TextStyle(
                                                                                    fontSize: textScaler.scale(16),
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            )
                                                            .toList()),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Text(
                              "Product",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sales.salesUser.title,
                                    style: TextStyle(
                                        fontSize: textScaler.scale(18),
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "₹${sales.salesUser.price}.00",
                                        style: TextStyle(
                                          fontSize: textScaler.scale(18),
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        "${sales.salesUser.qty} Qty",
                                        style: TextStyle(
                                          fontSize: textScaler.scale(16),
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: sales.salesUser.dateController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff072942),
                                    ),
                                    enabled: false,
                                    cursorColor: const Color(0xff6AABDA),
                                    decoration: InputDecoration(
                                      hintText: "MM/DD/YYYY",
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
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('MM/dd/yyyy')
                                                .format(pickedDate);

                                        sales.getDateValue(
                                            formattedDate: formattedDate);
                                      }
                                    },
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Qty",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: h * 0.06,
                              width: w * 0.3,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xff35383f).withOpacity(0.85),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        sales.decreaseQty();
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        size: h * 0.03,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${sales.salesUser.qty}",
                                        style: TextStyle(
                                          fontSize: textScaler.scale(18),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      onPressed: () {
                                        sales.increaseQty();
                                      },
                                      icon: Icon(
                                        size: h * 0.03,
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Ink(
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      log("*****************");
                                      FCMHelper.fcmHelper
                                          .updateTheQTYProduct(
                                        title: sales.salesUser.title,
                                        qty: sales.salesUser.qty,
                                        price: sales.salesUser.price.toDouble(),
                                      )
                                          .then((value) {
                                        SnackBar snackBar = SnackBar(
                                          content:
                                              const Text("Data CheckOuted..."),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.5),
                                          dismissDirection:
                                              DismissDirection.horizontal,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      });
                                      FCMHelper.fcmHelper.setProductHistory(
                                        title: sales.salesUser.title,
                                        qty: sales.salesUser.qty,
                                        date:
                                            sales.salesUser.dateController.text,
                                        category:
                                            sales.salesUser.category ?? "",
                                      );
                                      sales.salesUser.qty = 1;
                                      log("*****************");
                                    },
                                    splashColor: Colors.white30,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        "Checkout ➡️",
                                        style: TextStyle(
                                          fontSize: textScaler.scale(20),
                                          color: Colors.white,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
