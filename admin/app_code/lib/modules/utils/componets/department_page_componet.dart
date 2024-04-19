import 'package:app_code/modules/utils/componets/request_page_componet.dart';
import 'package:app_code/modules/utils/controllers/department_page_controller.dart';
import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/modules/utils/models/department_page_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../globals/routes.dart';

class DepartmentPageComponet extends StatelessWidget {
  DepartmentPageComponet({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: RequestModel.myProduct);
    TextEditingController priceController = TextEditingController();
    TextEditingController qtyController = TextEditingController(
        text: (RequestModel.myQty == 0) ? "" : RequestModel.myQty.toString());
    TextEditingController categoryController =
        TextEditingController(text: RequestModel.myCategory);
    TextEditingController descriptionController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.textScalerOf(context);
    return Consumer<DepartmentPageController>(
        builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.all(h * 0.015),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        provider.pickProfileImage(image: ImageSource.gallery);
                      },
                      child: Container(
                        height: h * 0.3,
                        width: w * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (provider.departmentPageModel.image != null)
                                ? FileImage(provider.departmentPageModel.image!)
                                : const AssetImage(
                                        "assets/images/department_page_images/department.png")
                                    as ImageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.07,
                              child: TextFormField(
                                maxLines: 3,
                                textInputAction: TextInputAction.next,
                                controller: titleController,
                                validator: (val) =>
                                    val!.isEmpty ? "Enter title" : null,
                                onSaved: (val) {
                                  provider.departmentPageModel.title = val!;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter title",
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Price",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.06,
                              child: TextFormField(
                                controller: priceController,
                                validator: (val) =>
                                    val!.isEmpty ? "Enter price" : null,
                                onSaved: (val) {
                                  provider.departmentPageModel.price =
                                      int.parse(val ?? "0");
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter price",
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Qty",
                              style: TextStyle(
                                fontSize: textScaler.scale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: h * 0.06,
                              child: TextFormField(
                                controller: qtyController,
                                validator: (val) =>
                                    val!.isEmpty ? "Enter qty" : null,
                                onSaved: (val) {
                                  provider.departmentPageModel.qty =
                                      int.parse(val ?? "0");
                                },
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Enter qty",
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.03),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: textScaler.scale(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: h * 0.07,
                  child: TextFormField(
                    controller: categoryController,
                    validator: (val) => val!.isEmpty ? "Enter category" : null,
                    onSaved: (val) {
                      provider.departmentPageModel.category = val ?? "";
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Enter category",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.03),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: textScaler.scale(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  maxLines: 4,
                  validator: (val) => val!.isEmpty ? "Enter description" : null,
                  onSaved: (val) {
                    provider.departmentPageModel.description = val ?? "";
                  },
                  controller: descriptionController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(w * 0.03),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
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
                    value: provider.departmentPageModel.department,
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
                      // provider.storeDepartment(department: value! as String);
                      provider.getDepartmentPageData(
                          department: value as String);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(h * 0.02),
                      child: TextButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            DepartmentPageModel departmentPageModel =
                                DepartmentPageModel(
                              image: provider.departmentPageModel.image,
                              title: provider.departmentPageModel.title,
                              price: provider.departmentPageModel.price,
                              qty: provider.departmentPageModel.qty,
                              category: provider.departmentPageModel.category,
                              description:
                                  provider.departmentPageModel.description,
                              department:
                                  provider.departmentPageModel.department,
                            );
                            FCMHelper.fcmHelper
                                .addDepartmentWiseData(departmentPageModel);

                            titleController.clear();
                            qtyController.clear();
                            categoryController.clear();
                            priceController.clear();
                            descriptionController.clear();
                            provider.assignNullValue();

                            SnackBar snackBar = const SnackBar(
                              content: Text("Data Added Successfully"),
                              backgroundColor: Colors.green,
                              margin: EdgeInsets.all(5),
                              dismissDirection: DismissDirection.horizontal,
                              behavior: SnackBarBehavior.floating,
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        icon: const Icon(Icons.inventory_2),
                        label: Text(
                          "Add Product",
                          style: TextStyle(
                            fontSize: textScaler.scale(20),
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
    });
  }
}
