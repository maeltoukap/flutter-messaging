import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'hive_message.g.dart';

@HiveType(typeId: 1)
class LocalMessageModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? provider = "me";
  @HiveField(2)
  String? sendDateTime;
  // Timestamp? sendDateTime = Timestamp.now();
  @HiveField(3)
  bool hasBeenRead;
  @HiveField(4)
  String? message;
  // @HiveField(5)
  // String receiverFCM;
  @HiveField(5)
  String senderUid;
  @HiveField(6)
  String receiverUid;
  @HiveField(7)
  bool containFiles;
  @HiveField(8)
  String? fileUrl;
  @HiveField(9)
  String? groupDateTime;
  @HiveField(10)
  bool? haveBeenSend = false;

  LocalMessageModel({
    this.id,
    this.provider,
    required this.message,
    this.sendDateTime,
    // required this.receiverFCM,
    required this.senderUid,
    required this.receiverUid,
    required this.containFiles,
    required this.fileUrl,
    required this.hasBeenRead,
    this.groupDateTime,
    this.haveBeenSend,
  });

  static List<LocalMessageModel> fromQuerySnapshot(
      QuerySnapshot querySnapshot, List<LocalMessageModel> messages) {
    for (final doc in querySnapshot.docs) {
      print(doc['sendDateTime']);
      final message = LocalMessageModel(
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

  static LocalMessageModel fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    final message = LocalMessageModel(
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

  // LocalMessageModel copy(
  //         {int? id,
  //         String? provider = "me",
  //         Timestamp? sendDateTime,
  //         bool? hasBeenRead,
  //         String? message,
  //         // String receiverFCM;
  //         String? senderUid,
  //         String? receiverUid,
  //         bool? containFiles,
  //         String? fileUrl,
  //         String? groupDateTime}) =>
  //     LocalMessageModel(
  //         id: id ?? this.id,
  //         sendDateTime: sendDateTime ?? this.sendDateTime,
  //         hasBeenRead: hasBeenRead ?? this.hasBeenRead,
  //         message: message ?? this.message,
  //         senderUid: senderUid ?? this.senderUid,
  //         receiverUid: receiverUid ?? this.receiverUid,
  //         containFiles: containFiles ?? this.containFiles,
  //         fileUrl: fileUrl ?? this.fileUrl,
  //         groupDateTime: groupDateTime ?? this.groupDateTime);
}
