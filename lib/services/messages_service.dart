// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wordpress_app/models/discussion_model.dart';
// import 'package:wordpress_app/models/message.dart';
// import 'package:http/http.dart' as http;

// class MessagesService {
//   void getReceiverToken(Message message) async {
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(message.receiverUid.trim())
//         .get()
//         .then((value) {
//       Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
//       String receiverToken = data["fcmToken"];
//       setNotification(receiverToken, message);
//       print(receiverToken);
//       print(value.exists);
//       // return data["fcmToken"];
//     });
//     // print(user);
//     // return receiverToken;
//   }

//   sendMessages(DiscussionModel discussion, Message message) async {
//     // _messages.clear();
//     // print("nvkdfjkdjfkd" + message.senderUid.trim());

//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection("discussions")
//         .doc(discussion.uid)
//         .collection("Messages")
//         .add(message.toMap());
//     // messages.add(message.toMap());
//     // print(messages.length);
//     // notifyListeners();

//     message.provider = "external";
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(message.receiverUid.trim())
//         .collection("Discussions")
//         .doc(discussion.uid)
//         .collection("Messages")
//         .add(message.toMap())
//         .then((value) {
//       getReceiverToken(message);
//     });
//   }

//   Future setNotification(String token, Message message) async {
//     if (token.isNotEmpty) {
//       var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
//       var request = http.Request(
//           'POST',
//           Uri.parse(
//               'https://ceramic-pay.000webhostapp.com/Downloads/messaging.php'));
//       request.bodyFields = {
//         'token': token,
//         'sender': 'Mael Toukap',
//         'message': message.message ?? "File"
//       };
//       request.headers.addAll(headers);

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//       } else {
//         print(response.reasonPhrase);
//       }
//     } else {
//       print("Token is null");
//     }
//   }

//   // checkDiscussion(DiscussionModel discussion, Message message) async {
//   //   // print(receiverUid);
//   //   await FirebaseFirestore.instance
//   //       .collection('Users')
//   //       .doc(FirebaseAuth.instance.currentUser!.uid)
//   //       .collection("Conversations")
//   //       .where("admin", arrayContains: message.receiverUid)
//   //       .get()
//   //       .then((QuerySnapshot querySnapshot) async {
//   //     if (querySnapshot.size > 0) {
//   //       querySnapshot.docs.forEach((doc) async {
//   //         await FirebaseFirestore.instance
//   //             .collection('Users')
//   //             .doc(FirebaseAuth.instance.currentUser!.uid)
//   //             .collection("discussions")
//   //             .doc(doc.id)
//   //             .update(discussion.toMap());
//   //       });
//   //     } else {
//   //       await FirebaseFirestore.instance
//   //           .collection('Users')
//   //           .doc(FirebaseAuth.instance.currentUser!.uid)
//   //           .collection("discussions")
//   //           .add(discussion.toMap());

//   //       print('Document does not exist on the database');
//   //     }
//   //     sendMessages(discussion, message);
//   //   });
//   // }
// }
