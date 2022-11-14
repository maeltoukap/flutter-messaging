import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final String tableMessage = "messages";

class MessageFields {
  static final List<String> values = [
    id,
    provider,
    hasBeenRead,
    message,
    senderUid,
    receiverUid,
    containsFiles,
    fileUrl,
    groupDataTime
  ];

  static final String id = "_id";
  static final String provider = "provider";
  static final String hasBeenRead = "hasBeenRead";
  static final String message = "message";
  static final String senderUid = "senderUid";
  static final String receiverUid = "receiverUid";
  static final String containsFiles = "containsFiles";
  static final String fileUrl = "fileUrl";
  static final String groupDataTime = "groupDataTime";
}

class Message {
  int? id;
  String? provider = "me";
  Timestamp? sendDateTime = Timestamp.now();
  bool hasBeenRead;
  String? message;
  // String receiverFCM;
  String senderUid;
  String receiverUid;
  bool containFiles;
  String? fileUrl;
  String? groupDateTime;

  Message(
      {this.id,
      this.provider,
      required this.message,
      this.sendDateTime,
      // required this.receiverFCM,
      required this.senderUid,
      required this.receiverUid,
      required this.containFiles,
      required this.fileUrl,
      required this.hasBeenRead,
      this.groupDateTime});

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
        groupDateTime: doc['groupDateTime'],
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
      groupDateTime: documentSnapshot['groupDateTime'],
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
        'groupDateTime': DateFormat.yMMMMd('en_US').format(DateTime.now())
        // "receiverFCM": receiverFCM
      };

  Map<String, dynamic> toMapForLocal() => {
        "provider": provider ?? "me",
        "sendDateTime": Timestamp.now().toString(),
        "hasBeenRead": hasBeenRead ? 1 : 0,
        "message": message,
        "senderUid": senderUid,
        "receiverUid": receiverUid,
        "containFile": containFiles ? 1 : 0,
        "fileUrl": fileUrl,
        'groupDateTime':
            DateFormat.yMMMMd('en_US').format(DateTime.now()).toString()
        // "receiverFCM": receiverFCM
      };

  Message copy(
          {int? id,
          String? provider = "me",
          Timestamp? sendDateTime,
          bool? hasBeenRead,
          String? message,
          // String receiverFCM;
          String? senderUid,
          String? receiverUid,
          bool? containFiles,
          String? fileUrl,
          String? groupDateTime}) =>
      Message(
          id: id ?? this.id,
          sendDateTime: sendDateTime ?? this.sendDateTime,
          hasBeenRead: hasBeenRead ?? this.hasBeenRead,
          message: message ?? this.message,
          senderUid: senderUid ?? this.senderUid,
          receiverUid: receiverUid ?? this.receiverUid,
          containFiles: containFiles ?? this.containFiles,
          fileUrl: fileUrl ?? this.fileUrl,
          groupDateTime: groupDateTime ?? this.groupDateTime);
}
