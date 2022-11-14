import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordpress_app/hive/boxes.dart';
import 'package:wordpress_app/hive/hive_message.dart';
import 'package:wordpress_app/models/chat_message.dart';
import 'package:wordpress_app/models/conversation_model.dart';
import 'package:wordpress_app/models/discussion_model.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/services/file_sevice.dart';
import 'package:wordpress_app/services/messages_service.dart';
import 'package:wordpress_app/utils/loading_card.dart';
import 'package:wordpress_app/utils/navigation.dart';

class ChatDetails extends StatefulWidget {
  ChatDetails(
      {Key? key,
      this.discussions,
      this.conversationModel,
      required this.pageProvider})
      : super(key: key);
  DiscussionModel? discussions;
  ConversationModel? conversationModel;
  String pageProvider;
  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

String receiverUid = "";
String conversationUid = "";
String receiverToken = "";
// getConversationUid() async {
//   await FirebaseFirestore.instance
//       .collection('Users')
//       .doc(FirebaseAuth.instance.currentUser!.uid.trim())
//       .collection("Conversations")
//       .where("user1", isEqualTo: receiverUid)
//       .where("user2", isEqualTo: FirebaseAuth.instance.currentUser!.uid.trim())
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     querySnapshot.docs.forEach((doc) async {
//       conversationUid = doc.id;
//     });
//   });
// }

getConversationUid() async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid.trim())
      .collection("Conversations")
      .where("user1", isEqualTo: receiverUid)
      .where("user2", isEqualTo: FirebaseAuth.instance.currentUser!.uid.trim())
      .get()
      .then((QuerySnapshot querySnapshot) {
    print("query size" + querySnapshot.size.toString());
    querySnapshot.docs.forEach((doc) async {
      conversationUid = doc.id;
    });
  });

  receiverToken = await MessagesService().getReceiverToken(receiverUid);
  // print("receiver token " + receiverToken.toString());
}

List messages = [];

// addMessagesToHive(Message msg, bool hasBeenSend) {
//   final mes = LocalMessageService(message: msg, hasBeenSend: hasBeenSend);
//   final box = Boxes.getMessages();
//   box.add(mes);
//   // return mes;
// }

class _ChatDetailsState extends State<ChatDetails> {
  TextEditingController messagesController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("receiverUid" + widget.discussions!.user1 + "end");
    receiverUid = widget.pageProvider != "Conversations"
        ? widget.conversationModel!.chatUsers.user.uid!
        : widget.discussions!.user1;
    getConversationUid();
    // print(FirebaseAuth.instance.);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box("Messages").close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    nextScreenReplace(context, HomePage());
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  // backgroundImage: NetworkImage(
                  //     "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.pageProvider != "Conversations"
                            ? widget.conversationModel!.chatUsers.user.userName!
                            : widget.discussions!.receiverUsername,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: widget.pageProvider == "Conversations"
                  ? FirebaseFirestore.instance
                      .collection('Users')
                      // .doc(uid)
                      .doc(FirebaseAuth.instance.currentUser!.uid.trim())
                      .collection("Conversations")
                      .doc(widget.discussions!.uid)
                      .collection("Messages")
                      // .where("user1", isEqualTo: receiverUid)
                      // .where("user2",
                      //     isEqualTo: FirebaseAuth.instance.currentUser!.uid.trim())
                      .orderBy("sendDateTime", descending: false)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Users')
                      // .doc(uid)
                      .doc(FirebaseAuth.instance.currentUser!.uid.trim())
                      .collection("Conversations")
                      .doc("widget.discussions!.uid")
                      .collection("Messages")
                      // .where("user1", isEqualTo: receiverUid)
                      // .where("user2",
                      //     isEqualTo: FirebaseAuth.instance.currentUser!.uid.trim())
                      .orderBy("sendDateTime", descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                // print("data size " + snapshot.data!.size.toString());
                // print(snapshot.data!.size);
                print("sjajkh" + conversationUid);
                // print(FirebaseAuth.instance.currentUser!.uid);
                if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: const Text("Something went wrong"),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return LoadingCard(
                      height: MediaQuery.of(context).size.height);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingCard(
                      height: MediaQuery.of(context).size.height);
                }
                for (int i = 0; i < snapshot.data!.size; i++) {
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    messages.add(Message.fromDocumentSnapshot(document));
                  });
                }
                messages = snapshot.data!.docs;
                print(messages);
                return SingleChildScrollView(
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 60.0),
                        shrinkWrap: true,
                        itemCount: messages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    messages[index]["groupDateTime"],
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                ),
                                Container(
                                  padding: messages[index]["fileUrl"] == null
                                      ? const EdgeInsets.only(
                                          left: 14,
                                          right: 14,
                                          top: 10,
                                          bottom: 10)
                                      : messages[index]["fileUrl"] != null &&
                                              messages[index]["provider"] !=
                                                  "external"
                                          ? const EdgeInsets.only(
                                              left: 180.0,
                                              right: 14,
                                              top: 10,
                                              bottom: 10)
                                          : const EdgeInsets.only(
                                              left: 14.0,
                                              right: 180.0,
                                              top: 10,
                                              bottom: 10),
                                  child: Align(
                                    alignment: (messages[index]["provider"] ==
                                            "external" //TODO: change to receiver
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: messages[index]["message"] != null ||
                                            messages[index]["message"] == ""
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: (messages[index]
                                                              ["provider"] ==
                                                          "external" //TODO: change to receiver
                                                      ? Colors.grey.shade200
                                                      : Colors.blue[200]),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Text(
                                                  messages[index]["message"],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0,
                                                        horizontal: 8.0),
                                                child: Text(
                                                  DateFormat('HH:mm a').format(
                                                      messages[index]
                                                              ["sendDateTime"]
                                                          .toDate()),
                                                  style:
                                                      TextStyle(fontSize: 10.0),
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(
                                            width: 300,
                                            height: 250,
                                            child: Image.network(
                                              messages[index]["fileUrl"],
                                              fit: BoxFit.cover,
                                            )),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            if (messages[index]["groupDateTime"] ==
                                messages[index - 1]["groupDateTime"]) {
                              return Container(
                                padding: messages[index]["fileUrl"] == null
                                    ? const EdgeInsets.only(
                                        left: 14,
                                        right: 14,
                                        top: 10,
                                        bottom: 10)
                                    : messages[index]["fileUrl"] != null &&
                                            messages[index]["provider"] !=
                                                "external"
                                        ? const EdgeInsets.only(
                                            left: 180.0,
                                            right: 14,
                                            top: 10,
                                            bottom: 10)
                                        : const EdgeInsets.only(
                                            left: 14.0,
                                            right: 180.0,
                                            top: 10,
                                            bottom: 10),
                                child: Align(
                                  alignment: (messages[index]["provider"] ==
                                          "external" //TODO: change to receiver
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: messages[index]["message"] != null ||
                                          messages[index]["message"] == ""
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: (messages[index]
                                                            ["provider"] ==
                                                        "external" //TODO: change to receiver
                                                    ? Colors.grey.shade200
                                                    : Colors.blue[200]),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                messages[index]["message"],
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 8.0),
                                              child: Text(
                                                DateFormat('HH:mm a').format(
                                                    messages[index]
                                                            ["sendDateTime"]
                                                        .toDate()),
                                                style:
                                                    TextStyle(fontSize: 10.0),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(
                                          width: 300,
                                          height: 250,
                                          child: Image.network(
                                            messages[index]["fileUrl"],
                                            fit: BoxFit.cover,
                                          )),
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  Text(
                                    messages[index]["groupDateTime"],
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                  Container(
                                    padding: messages[index]["fileUrl"] == null
                                        ? const EdgeInsets.only(
                                            left: 14,
                                            right: 14,
                                            top: 10,
                                            bottom: 10)
                                        : messages[index]["fileUrl"] != null &&
                                                messages[index]["provider"] !=
                                                    "external"
                                            ? const EdgeInsets.only(
                                                left: 180.0,
                                                right: 14,
                                                top: 10,
                                                bottom: 10)
                                            : const EdgeInsets.only(
                                                left: 14.0,
                                                right: 180.0,
                                                top: 10,
                                                bottom: 10),
                                    child: Align(
                                      alignment: (messages[index]["provider"] ==
                                              "external" //TODO: change to receiver
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                      child: messages[index]["message"] !=
                                                  null ||
                                              messages[index]["message"] == ""
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: (messages[index]
                                                                ["provider"] ==
                                                            "external" //TODO: change to receiver
                                                        ? Colors.grey.shade200
                                                        : Colors.blue[200]),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(
                                                    messages[index]["message"],
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 6.0,
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    DateFormat('HH:mm a')
                                                        .format(messages[index]
                                                                ["sendDateTime"]
                                                            .toDate()),
                                                    style: TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Container(
                                              width: 300,
                                              height: 250,
                                              child: Image.network(
                                                messages[index]["fileUrl"],
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        }))
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   padding: const EdgeInsets.only(top: 10, bottom: 70),
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   children:
                    //       snapshot.data!.docs.map((DocumentSnapshot document) {
                    //     messages.add(Message.fromDocumentSnapshot(document));
                    //     Map<String, dynamic> data =
                    //         document.data()! as Map<String, dynamic>;

                    //     return Container(
                    //       padding: data["fileUrl"] == null
                    //           ? const EdgeInsets.only(
                    //               left: 14, right: 14, top: 10, bottom: 10)
                    //           : data["fileUrl"] != null &&
                    //                   data["provider"] != "external"
                    //               ? const EdgeInsets.only(
                    //                   left: 180.0, right: 14, top: 10, bottom: 10)
                    //               : const EdgeInsets.only(
                    //                   left: 14.0,
                    //                   right: 180.0,
                    //                   top: 10,
                    //                   bottom: 10),
                    //       child: Align(
                    //         alignment: (data["provider"] ==
                    //                 "external" //TODO: change to receiver
                    //             ? Alignment.topLeft
                    //             : Alignment.topRight),
                    //         child: data["message"] != null ||
                    //                 data["message"] == ""
                    //             ? Column(
                    //                 mainAxisAlignment: MainAxisAlignment.end,
                    //                 crossAxisAlignment: CrossAxisAlignment.end,
                    //                 children: [
                    //                   Container(
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                       color: (data["provider"] ==
                    //                               "external" //TODO: change to receiver
                    //                           ? Colors.grey.shade200
                    //                           : Colors.blue[200]),
                    //                     ),
                    //                     padding: const EdgeInsets.all(16),
                    //                     child: Text(
                    //                       data["message"],
                    //                       style: const TextStyle(fontSize: 15),
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         vertical: 6.0, horizontal: 8.0),
                    //                     child: Text(
                    //                       DateFormat('HH:mm a').format(
                    //                           data["sendDateTime"].toDate()),
                    //                       style: TextStyle(fontSize: 10.0),
                    //                     ),
                    //                   )
                    //                 ],
                    //               )
                    //             : Container(
                    //                 width: 300,
                    //                 height: 250,
                    //                 child: Image.network(
                    //                   data["fileUrl"],
                    //                   fit: BoxFit.cover,
                    //                 )),
                    //       ),
                    //     );
                    //     // data["message"] == null
                    //     //     ? Container(
                    //     //         width: 300,
                    //     //         height: 250,
                    //     //         child: Image.network(
                    //     //           data["fileUrl"],
                    //     //           fit: BoxFit.cover,
                    //     //         ))
                    //     //     : Text(data["message"]);
                    //   }).toList(),
                    // ),
                    );
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      Message message = Message(
                          hasBeenRead: false,
                          message: null,
                          receiverUid: receiverUid,
                          senderUid: FirebaseAuth.instance.currentUser!.uid,
                          containFiles: true,
                          fileUrl: "");
                      // await FileService().getImage("Gallery", message);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: messagesController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      Message message = Message(
                          hasBeenRead: false,
                          message: null,
                          receiverUid: receiverUid,
                          senderUid: FirebaseAuth.instance.currentUser!.uid,
                          containFiles: true,
                          fileUrl: "");
                      // await FileService().getImage("Camera", message);
                      setState(() {
                        messagesController.text = "";
                      });
                    },
                    backgroundColor: Colors.white,
                    elevation: 0,
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                    heroTag: "btn1",
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      final SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      String? _userName = sp.getString('user_name');
                      Message message = Message(
                          hasBeenRead: false,
                          message: messagesController.text,
                          receiverUid: receiverUid,
                          senderUid: FirebaseAuth.instance.currentUser!.uid,
                          containFiles: false,
                          fileUrl: null);

                      DiscussionModel discussion = DiscussionModel(
                          // admin: "",
                          lastestMessage: messagesController.text,
                          latestProvider: message.senderUid,
                          isLastMessageHasBeenRead: false,
                          creationDateTime: Timestamp.now(),
                          user1: message.receiverUid,
                          user2: message.senderUid,
                          receiverEmail: widget.pageProvider != "Conversations"
                              ? widget
                                  .conversationModel!.chatUsers.user.userEmail!
                              : widget.discussions!.receiverEmail,
                          senderEmail:
                              FirebaseAuth.instance.currentUser!.email!,
                          receiverUsername:
                              widget.pageProvider != "Conversations"
                                  ? widget.conversationModel!.chatUsers.user
                                      .userName!
                                  : widget.discussions!.receiverUsername,
                          //  widget.discussions.receiverUsername,
                          senderUsername: widget.pageProvider != "Conversations"
                              ? FirebaseAuth.instance.currentUser!.email!
                              : widget.discussions!.receiverEmail
                          //  widget.discussions.senderUsername,
                          );
                      widget.discussions = discussion;

                      // setState(() {
                      //   widget.pageProvider = "Conversations";
                      // });
                      messagesController.text = "";
                      // MessagesService().setNotification(receiverToken, message);
                      // MessagesService()
                      //     .checkSenderDiscussion(discussion, message);
                      // MessagesService()
                      //     .checkReceiverDiscussion(discussion, message);

                      // print("receiver token " + receiverToken);
                      // if (receiverToken.isNotEmpty) {
                      //   MessagesService()
                      //       .setNotification(receiverToken, message);
                      // }
                      // setState(() {
                      // });
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    heroTag: "btn2",
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
