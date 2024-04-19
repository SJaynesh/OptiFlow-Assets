import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../modules/utils/helpers/fcm_helper.dart';
import '../../../modules/utils/helpers/firebase_auth_helper.dart';
import '../../../modules/utils/models/user_chat_model.dart';
import 'live_chat_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;

    TextScaler textScaler = MediaQuery.of(context).textScaler;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(h * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Messages",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: textScaler.scale(30),
                ),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FCMHelper.fcmHelper.getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                          data?.docs ?? [];

                      List<UserChatModel> allUserData = docs
                          .map((e) => UserChatModel.fromMap(e.data()))
                          .toList();

                      return ListView.builder(
                        itemCount: allUserData.length,
                        itemBuilder: (context, index) {
                          UserChatModel data = allUserData[index];

                          return Padding(
                            padding: EdgeInsets.only(bottom: h * 0.01),
                            child: (data.email ==
                                    FireBaseAuthHelper.firebaseAuth.firebase
                                        .currentUser?.email)
                                ? Container()
                                : ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              LiveChatPage(userChatModel: data),
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          reverseTransitionDuration:
                                              const Duration(seconds: 1),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    leading: Transform.scale(
                                      scaleX: 1.5,
                                      scaleY: 1.5,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(w * 0.045),
                                        child: Image.network(data.profileImage),
                                      ),
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.only(left: w * 0.06),
                                      child: Text(
                                        data.fullName,
                                        style: TextStyle(
                                          fontSize: textScaler.scale(20),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(left: w * 0.06),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.bio,
                                            style: TextStyle(
                                              fontSize: textScaler.scale(14),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            data.email,
                                            style: TextStyle(
                                              fontSize: textScaler.scale(12),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          Text(
                                            data.department,
                                            style: TextStyle(
                                              fontSize: textScaler.scale(12),
                                              color: Colors.brown,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          );
                        },
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
      ),
    );
  }
}
