import 'package:app_code/view/modules/utils/globals/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modules/utils/controllers/product_controller.dart';
import '../../chat_page_screen/screen/chat_page.dart';

class ShopPageScreen extends StatelessWidget {
  const ShopPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
              ),
              label: Text(
                "Back",
                style: TextStyle(
                  fontSize: textScaler.scale(18),
                  color: Colors.grey,
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Shop",
              style: TextStyle(
                fontSize: textScaler.scale(25),
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
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
        centerTitle: true,
        backgroundColor: const Color(0xffF2F2F2),
      ),
      backgroundColor: const Color(0xffF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...Provider.of<ProductController>(context)
                  .productModel
                  .Categories
                  .map(
                    (e) => ExpansionTile(
                      shape: const RoundedRectangleBorder(),
                      title: Text(
                        e,
                        style: TextStyle(
                          fontSize: textScaler.scale(22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ...Provider.of<ProductController>(context)
                            .productModel
                            .Products
                            .map(
                              (element) => (element.category == e)
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            Routes.detailPageScreen,
                                            arguments: {
                                              'color': Colors.primaries[
                                                      Provider.of<ProductController>(
                                                                  context,
                                                                  listen: false)
                                                              .productModel
                                                              .Products
                                                              .indexOf(
                                                                  element) %
                                                          18]
                                                  .withOpacity(0.3),
                                              'data': element,
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.primaries[
                                                  Provider.of<ProductController>(
                                                              context,
                                                              listen: true)
                                                          .productModel
                                                          .Products
                                                          .indexOf(element) %
                                                      18]
                                              .withOpacity(0.25),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: h * 0.15,
                                                width: w * 0.3,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        element.image),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      element.title,
                                                      style: TextStyle(
                                                          fontSize: textScaler
                                                              .scale(18),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    SizedBox(
                                                      height: h * 0.01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "\$${element.price}.00",
                                                          style: TextStyle(
                                                            fontSize: textScaler
                                                                .scale(18),
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.2,
                                                        ),
                                                        Text(
                                                          "${element.qty} Qty",
                                                          style: TextStyle(
                                                            fontSize: textScaler
                                                                .scale(16),
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                      ],
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
