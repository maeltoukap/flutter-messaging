import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/tabs/conversations_tab.dart';

class DiscussionModel {
  String? uid;
  String admin;
  String lastestMessage;
  String latestProvider;
  bool isLastMessageHasBeenRead;
  String creattionDateTime;
  // Message message;

  DiscussionModel(
      {this.uid,
      required this.admin,
      required this.lastestMessage,
      required this.latestProvider,
      // required this.receiverFCM,
      required this.isLastMessageHasBeenRead,
      required this.creattionDateTime,
      // required this.message
      });

  static List<DiscussionModel> fromQuerySnapshot(
      QuerySnapshot querySnapshot, List<DiscussionModel> messages) {
    for (final doc in querySnapshot.docs) {
      print(doc['sendDateTime']);
      final message = DiscussionModel(
        uid: doc['uid'],
        admin: doc['admin'],
        lastestMessage: doc['lastestMessage'],
        latestProvider: doc['latestProvider'],
        isLastMessageHasBeenRead: doc['isLastMessageHasBeenRead'],
        creattionDateTime: doc['creattionDateTime'],
        // message: doc['messages'],
        // receiverFCM: doc["receiverFCM"],
      );
      messages.add(message);
    }
    return messages;
  }

  static DiscussionModel fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    final message = DiscussionModel(
      uid: documentSnapshot['uid'],
      admin: documentSnapshot['admin'],
      lastestMessage: documentSnapshot['lastestMessage'],
      latestProvider: documentSnapshot['latestProvider'],
      isLastMessageHasBeenRead: documentSnapshot['isLastMessageHasBeenRead'],
      creattionDateTime: documentSnapshot['creattionDateTime'],
      // message: documentSnapshot['messages'],
      // receiverFCM: documentSnapshot["receiverFCM"]
    );
    return message;
  }

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "admin": admin,
        "creattionDateTime": Timestamp.now(),
        "lastestMessage": lastestMessage,
        "isLastMessageHasBeenRead": isLastMessageHasBeenRead,
        "latestProvider": latestProvider,
        // "messages": messages,
      };
}
