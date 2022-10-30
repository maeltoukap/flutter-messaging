import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/chat_message.dart';
import 'package:wordpress_app/models/conversation_model.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/services/file_sevice.dart';
import 'package:wordpress_app/services/messages_service.dart';
import 'package:wordpress_app/utils/loading_card.dart';

class ChatDetails extends StatefulWidget {
  ChatDetails({Key? key, required this.conversationMessages}) : super(key: key);
  ConversationModel conversationMessages;
  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  TextEditingController messagesController = TextEditingController();
  String receiverUid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("receiverUid" +
        widget.conversationMessages.chatUsers.user.uid! +
        "end");
    receiverUid = widget.conversationMessages.chatUsers.user.uid!.trim();
    // print(FirebaseAuth.instance.);
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
                    Navigator.pop(context);
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
                        widget.conversationMessages.chatUsers.user.userName!,
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
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  // .doc(uid)
                  .doc(FirebaseAuth.instance.currentUser!.uid.trim())
                  .collection("Messages")
                  // .where("receiverUid", isEqualTo: receiverUid)
                  .where("senderUid", isEqualTo: receiverUid)
                  .orderBy("sendDateTime", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                // print(snapshot.data!.size);
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
                return SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 70),
                    physics: const NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Container(
                        padding: data["fileUrl"] == null
                            ? const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10)
                            : data["fileUrl"] != null &&
                                    data["provider"] != "external"
                                ? const EdgeInsets.only(
                                    left: 180.0, right: 14, top: 10, bottom: 10)
                                : const EdgeInsets.only(
                                    left: 14.0,
                                    right: 180.0,
                                    top: 10,
                                    bottom: 10),
                        child: Align(
                          alignment: (data["provider"] ==
                                  "external" //TODO: change to receiver
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child:
                              data["message"] != null || data["message"] == ""
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (data["provider"] ==
                                                "external" //TODO: change to receiver
                                            ? Colors.grey.shade200
                                            : Colors.blue[200]),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        data["message"],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    )
                                  : Container(
                                      width: 300,
                                      height: 250,
                                      child: Image.network(
                                        data["fileUrl"],
                                        fit: BoxFit.cover,
                                      )),
                        ),
                      );
                      // data["message"] == null
                      //     ? Container(
                      //         width: 300,
                      //         height: 250,
                      //         child: Image.network(
                      //           data["fileUrl"],
                      //           fit: BoxFit.cover,
                      //         ))
                      //     : Text(data["message"]);
                    }).toList(),
                  ),
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
                          receiverUid:
                              widget.conversationMessages.chatUsers.user.uid!,
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
                          receiverUid:
                              widget.conversationMessages.chatUsers.user.uid!,
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
                    onPressed: () {
                      Message message = Message(
                          hasBeenRead: false,
                          message: messagesController.text,
                          receiverUid:
                              widget.conversationMessages.chatUsers.user.uid!,
                          senderUid: FirebaseAuth.instance.currentUser!.uid,
                          containFiles: false,
                          fileUrl: null);
                      // MessagesService().sendMessages(message);
                      setState(() {
                        messagesController.text = "";
                      });
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
