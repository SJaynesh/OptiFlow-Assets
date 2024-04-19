import 'dart:math';

import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:app_code/modules/utils/models/chat_model.dart';
import 'package:app_code/modules/utils/models/user_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../../../../modules/utils/helpers/firebase_auth_helper.dart';

class LiveChatPage extends StatelessWidget {
  UserChatModel userChatModel;
  LiveChatPage({
    super.key,
    required this.userChatModel,
  });
  String chat = "";
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffacbceb),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(w * 0.05),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(w * 0.045),
                        child: Image.network(userChatModel.profileImage),
                      ),
                      title: Text(
                        userChatModel.fullName,
                        style: TextStyle(
                          fontSize: textScaler.scale(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userChatModel.department,
                        style: TextStyle(
                          fontSize: textScaler.scale(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(w * 0.15),
                    topLeft: Radius.circular(w * 0.15),
                  ),
                ),
                padding: EdgeInsets.all(w * 0.08),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: StreamBuilder(
                        stream: FCMHelper.fcmHelper.getAllChart(
                            senderId: FireBaseAuthHelper
                                    .firebaseAuth.firebase.currentUser?.email ??
                                "",
                            receiverId: userChatModel.email),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("ERROR: ${snapshot.error}"),
                            );
                          } else if (snapshot.hasData) {
                            QuerySnapshot<Map<String, dynamic>>? data =
                                snapshot.data;

                            List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                docs = data?.docs ?? [];

                            List<ChatModal> allChatData = docs
                                .map((e) => ChatModal.fromMap(data: e.data()))
                                .toList();
                            return ListView.builder(
                              itemCount: allChatData.length,
                              itemBuilder: (context, index) {
                                ChatModal chatModal = allChatData[index];
                                if ((chatModal.type == "sender")) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: const Text(
                                                    "Delete message?",
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () {
                                                        FCMHelper.fcmHelper
                                                            .deleteChat(
                                                          senderId:
                                                              FireBaseAuthHelper
                                                                      .firebaseAuth
                                                                      .firebase
                                                                      .currentUser
                                                                      ?.email ??
                                                                  "",
                                                          receiverId:
                                                              userChatModel
                                                                  .email,
                                                          date: chatModal
                                                              .dateTime
                                                              .millisecondsSinceEpoch
                                                              .toString(),
                                                        )
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.redAccent,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(w * 0.02),
                                            margin: EdgeInsets.all(h * 0.01),
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff6f8fd),
                                              // color: Colors.green,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(w * 0.05),
                                                topRight:
                                                    Radius.circular(w * 0.05),
                                                bottomLeft:
                                                    Radius.circular(w * 0.05),
                                              ),
                                            ),
                                            child: Text(
                                              chatModal.msg,
                                              style: const TextStyle(
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.all(w * 0.02),
                                          margin: EdgeInsets.all(h * 0.01),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffacbceb)
                                                .withOpacity(0.5),
                                            // color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(w * 0.05),
                                              topRight:
                                                  Radius.circular(w * 0.05),
                                              bottomRight:
                                                  Radius.circular(w * 0.05),
                                            ),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              chatModal.msg,
                                              style: const TextStyle(
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: chatController,
                      onChanged: (val) {
                        chat = val;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xfff6f8fd),
                        hintText: "Type a message...",
                        prefixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.grey[500],
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(w * 0.02),
                          child: IconButton.filled(
                            color: Colors.white,
                            onPressed: () {
                              print("----------------------");
                              print("CLICK THE SEND BUTTON");
                              print("----------------------");
                              ChatModal chatModal = ChatModal(
                                chat,
                                "sender",
                                DateTime.now(),
                              );
                              FCMHelper.fcmHelper.sendChat(
                                senderId: FireBaseAuthHelper.firebaseAuth
                                        .firebase.currentUser?.email ??
                                    "",
                                receiverId: userChatModel.email,
                                chatModal: chatModal,
                              );
                              chatController.clear();
                            },
                            icon: Transform.rotate(
                              angle: pi * -0.2,
                              child: const Icon(Icons.send),
                            ),
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
