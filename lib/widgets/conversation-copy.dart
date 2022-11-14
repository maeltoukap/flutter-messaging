import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wordpress_app/models/chat_message.dart';
import 'package:wordpress_app/models/chat_user.dart';
import 'package:wordpress_app/models/conversation_model.dart';
import 'package:wordpress_app/models/discussion_model.dart';
import 'package:wordpress_app/pages/chat_detail.dart';
import 'package:wordpress_app/services/messages_service.dart';

class Conversation extends StatefulWidget {
  Conversation(
      {
      //required this.name,
      // required this.messageText,
      // required this.imageUrl,
      // required this.time,
      this.discussions,
      this.conversationModel,
      required this.pageProvider,
      required this.isMessageRead});
  // String name;
  // String messageText;
  // String imageUrl;
  // String time;
  DiscussionModel? discussions;
  ConversationModel? conversationModel;
  String pageProvider;
  bool isMessageRead;

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // DiscussionModel discussion = DiscussionModel(
        //     admin: "mael",
        //     lastestMessage: "",
        //     latestProvider: "",
        //     isLastMessageHasBeenRead: true,
        //     creattionDateTime: "");
        // FirebaseFirestore.instance
        //     .collection('Users')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .collection("Discussions")
        //     .doc()
        //     .collection("Messages")
        //     .add(discussion.toMap());
        // MessagesService()
        //     .checkDiscussion(widget.conversationModel.chatUsers.user.uid!);
        // FirebaseFirestore.instance
        //     .collection("Users")
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .collection("Conversations")
        //     .add({'creator': FirebaseAuth.instance.currentUser!.uid}).then(
        //         (value) => print(value));

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetails(
            discussions: widget.discussions,
            conversationModel: widget.conversationModel,
            pageProvider: widget.pageProvider,
          );
        }));
        // print(widget.discussions!.uid);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    // backgroundImage: AssetImage(widget.imageUrl),
                    // backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                // widget.discussions!.receiverUsername.isEmpty ? widget.conversationModel!.chatUsers.user.userEmail: widget.discussions!.receiverUsername,
                                widget.pageProvider != "Conversations"
                                    ? widget.conversationModel!.chatUsers.user
                                        .userName!
                                    : widget.discussions!.receiverUsername,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                // widget.discussions!.receiverEmail,
                                widget.pageProvider != "Conversations"
                                    ? widget.conversationModel!.chatUsers.user
                                        .userEmail!
                                    : widget.discussions!.lastestMessage,
                                // widget.conversationModel.chatUsers.messageText,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: widget.isMessageRead
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ],
                          ),
                          Text(
                            // widget.discussions!.receiverEmail,
                            widget.pageProvider != "Conversations"
                                ? widget.conversationModel!.chatUsers.user
                                    .userEmail!
                                : (widget.discussions!.creationDateTime ==
                                            Timestamp.now()
                                        ? "Now"
                                        : DateFormat('HH:mm a').format(widget
                                            .discussions!.creationDateTime
                                            .toDate()))
                                    .toString(),
                            // widget.conversationModel.chatUsers.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text(
            //   widget.conversationModel.chatUsers.time,
            //   style: TextStyle(
            //       fontSize: 12,
            //       fontWeight: widget.isMessageRead
            //           ? FontWeight.bold
            //           : FontWeight.normal),
            // ),
          ],
        ),
      ),
    );
  }
}
