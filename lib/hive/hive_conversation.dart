import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/tabs/conversations_tab.dart';

class DiscussionModel {
  String? uid;
  String? admin;
  String lastestMessage;
  String latestProvider;
  bool isLastMessageHasBeenRead;
  Timestamp creationDateTime;
  // Timestamp lastestMessageSendDateTime;
  String user1;
  String user2;
  String senderEmail;
  String receiverEmail;
  String senderUsername;
  String receiverUsername;
  // int countUnreadMessages;
  // Message message;

  DiscussionModel({
    this.uid,
    this.admin,
    required this.lastestMessage,
    required this.latestProvider,
    // required this.receiverFCM,
    required this.isLastMessageHasBeenRead,
    required this.creationDateTime,
    required this.user1,
    required this.user2,
    required this.senderEmail,
    required this.receiverEmail,
    required this.senderUsername,
    required this.receiverUsername,
    // required this.lastestMessageSendDateTime
    // required this.countUnreadMessages
    // required this.message
  });

  static List<DiscussionModel> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<DiscussionModel> messages = [];
    for (final doc in querySnapshot.docs) {
      print(doc['sendDateTime']);
      final message = DiscussionModel(
          uid: doc['uid'],
          admin: doc['admin'],
          lastestMessage: doc['lastestMessage'],
          latestProvider: doc['latestProvider'],
          isLastMessageHasBeenRead: doc['isLastMessageHasBeenRead'],
          creationDateTime: doc['creationDateTime'],
          user1: doc['user1'],
          user2: doc['user2'],
          senderEmail: doc['senderEmail'],
          receiverEmail: doc['receiverEmail'],
          receiverUsername: doc["receiverUsername"],
          senderUsername: doc['senderUsername'],
          // lastestMessageSendDateTime: doc['lastestMessageSendDateTime']
          // countUnreadMessages: doc['countUnreadMessages'],
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
        creationDateTime: documentSnapshot['creationDateTime'],
        user1: documentSnapshot['user1'],
        user2: documentSnapshot['user2'],
        senderEmail: documentSnapshot['senderEmail'],
        receiverEmail: documentSnapshot['receiverEmail'],
        receiverUsername: documentSnapshot["receiverUsername"],
        senderUsername: documentSnapshot['senderUsername'],
        // lastestMessageSendDateTime: documentSnapshot['lastestMessageSendDateTime']
        // countUnreadMessages: documentSnapshot['countUnreadMessages'],
        // message: documentSnapshot['messages'],
        // receiverFCM: documentSnapshot["receiverFCM"]
        );
    return message;
  }

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "admin": admin,
        "creationDateTime": Timestamp.now(),
        "lastestMessage": lastestMessage,
        "isLastMessageHasBeenRead": isLastMessageHasBeenRead,
        "latestProvider": latestProvider,
        "user1": user1,
        "user2": user2,
        "senderEmail": senderEmail,
        "receiverEmail": receiverEmail,
        "receiverUsername": receiverUsername,
        'senderUsername': senderUsername,
        // "lastestMessageSendDateTime": lastestMessageSendDateTime,
        // "countUnreadMessages": countUnreadMessages,
        // "message": message,
        // "messages": messages,
      };
}
