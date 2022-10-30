import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? provider = "me";
  Timestamp? sendDateTime = Timestamp.now();
  bool hasBeenRead;
  String? message;
  // String receiverFCM;
  String senderUid;
  String receiverUid;
  bool containFiles;
  String? fileUrl;

  Message(
      {this.provider,
      required this.message,
      this.sendDateTime,
      // required this.receiverFCM,
      required this.senderUid,
      required this.receiverUid,
      required this.containFiles,
      required this.fileUrl,
      required this.hasBeenRead});

  static List<Message> fromQuerySnapshot(
      QuerySnapshot querySnapshot, List<Message> messages) {
    for (final doc in querySnapshot.docs) {
      print(doc['sendDateTime']);
      final message = Message(
        provider: doc['provider'],
        sendDateTime: doc['sendDateTime'],
        hasBeenRead: doc['hasBeenRead'],
        message: doc['message'],
        senderUid: doc['senderUid'],
        containFiles: doc['containFiles'],
        fileUrl: doc['fileUrl'],
        receiverUid: doc['receiverUid'],
        // receiverFCM: doc["receiverFCM"],
      );
      messages.add(message);
    }
    return messages;
  }

  static Message fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final message = Message(
      provider: documentSnapshot['provider'],
      sendDateTime: documentSnapshot['sendDateTime'],
      hasBeenRead: documentSnapshot['hasBeenRead'],
      message: documentSnapshot['message'],
      senderUid: documentSnapshot['senderUid'],
      receiverUid: documentSnapshot['receiverUid'],
      containFiles: documentSnapshot['containFiles'],
      fileUrl: documentSnapshot['fileUrl'],
      // receiverFCM: documentSnapshot["receiverFCM"]
    );
    return message;
  }

  Map<String, dynamic> toMap() => {
        "provider": provider ?? "me",
        "sendDateTime": Timestamp.now(),
        "hasBeenRead": hasBeenRead,
        "message": message,
        "senderUid": senderUid,
        "receiverUid": receiverUid,
        "containFile": containFiles,
        "fileUrl": fileUrl,
        // "receiverFCM": receiverFCM
      };
}
