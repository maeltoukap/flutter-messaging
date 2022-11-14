import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordpress_app/hive/hive_message.dart';
import 'package:wordpress_app/models/discussion_model.dart';
import 'package:wordpress_app/models/message.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress_app/pages/user_list.dart';

class MessagesService {
  // Future<String> getReceiverToken(Message message) async {
  //   String receiverToken = "";
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(message.receiverUid.trim())
  //       .get()
  //       .then((value) {
  //     Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
  //     receiverToken = data["fcmToken"];
  //     // setNotification(receiverToken, message);
  //     print(receiverToken);
  //     print(value.exists);
  //     return data["fcmToken"];
  //   });
  //   return receiverToken;
  //   // print(user);
  //   // return receiverToken;
  // }
  Future<String> getReceiverToken(String receiverUid) async {
    String receiverToken = "";
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverUid.trim())
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
      receiverToken = data["fcmToken"];
      // setNotification(receiverToken, message);
      print(receiverToken);
      print(value.exists);
      return data["fcmToken"];
    });
    return receiverToken;
    // print(user);
    // return receiverToken;
  }

  sendMessages(DiscussionModel discussion, Message message) async {
    // _messages.clear();
    // print("nvkdfjkdjfkd" + message.senderUid.trim());
    // print("dISCUSSION UID" + discussion.uid.toString());
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(message.senderUid.trim())
        .collection("Conversations")
        .doc(discussion.uid)
        .collection("Messages")
        .add(message.toMap());
    // messages.add(message.toMap());
    // print(messages.length);
    // notifyListeners();

    message.provider = "external";
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(message.receiverUid.trim())
        .collection("Conversations")
        .doc(discussion.uid)
        .collection("Messages")
        .add(message.toMap())
        .then((value) {
      // getReceiverToken(message);
    });
  }

  Future setNotification(String token, Message message) async {
    if (token.isNotEmpty) {
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://ceramic-pay.000webhostapp.com/Downloads/messaging.php'));
      request.bodyFields = {
        'token': token,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'message': message.message ?? "File"
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } else {
      print("Token is null");
    }
  }

  checkSenderDiscussion(DiscussionModel discussion, Message message,
      LocalMessageModel localMessageModel) async {
    // print(receiverUid);
    ///Check for sender Uid
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(message.senderUid)
        .collection("Conversations")
        .where("user1", isEqualTo: message.receiverUid)
        .where("user2", isEqualTo: message.senderUid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // print(querySnapshot.size);
      if (querySnapshot.size > 0) {
        print(querySnapshot.size);
        querySnapshot.docs.forEach((doc) async {
          discussion.uid = doc.id;
          print(message.senderUid);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(message.senderUid)
              .collection("Conversations")
              .doc(doc.id)
              .update(discussion.toMap());
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(message.senderUid.trim())
              .collection("Conversations")
              .doc(doc.id)
              .collection("Messages")
              .add(message.toMap());
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(message.senderUid)
            .collection("Conversations")
            .add(discussion.toMap());

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(message.senderUid)
            .collection("Conversations")
            .where("user1", isEqualTo: message.receiverUid)
            .where("user2", isEqualTo: message.senderUid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0) {
            print(querySnapshot.size);
            querySnapshot.docs.forEach((document) async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(message.senderUid.trim())
                  .collection("Conversations")
                  .doc(document.id)
                  .collection("Messages")
                  .add(message.toMap());
            });
          }
        });
        print('Document does not exist on the database');
      }

      // sendMessages(discussion, message);
    });
    localMessageModel.haveBeenSend = true;
    localMessageModel.save();
  }

  checkReceiverDiscussion(DiscussionModel discussion, Message message) async {
    // print(receiverUid);
    ///Check for sender Uid
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(message.receiverUid)
        .collection("Conversations")
        .where("user1", isEqualTo: message.receiverUid)
        .where("user2", isEqualTo: message.senderUid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // print(querySnapshot.size);
      if (querySnapshot.size > 0) {
        print(querySnapshot.size);
        querySnapshot.docs.forEach((doc) async {
          discussion.uid = doc.id;
          print(message.receiverUid);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(message.receiverUid)
              .collection("Conversations")
              .doc(doc.id)
              .update(discussion.toMap());
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(message.receiverUid)
            .collection("Conversations")
            .add(discussion.toMap());

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(message.receiverUid)
            .collection("Conversations")
            .where("user1", isEqualTo: message.receiverUid)
            .where("user2", isEqualTo: message.senderUid)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0) {
            querySnapshot.docs.forEach((document) async {
              message.provider = "external";
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(message.receiverUid.trim())
                  .collection("Conversations")
                  .doc(document.id)
                  .collection("Messages")
                  .add(message.toMap())
                  .then((value) async {
                // setNotification(receiverToken, message);
                // getReceiverToken(message);
              });
            });

            // getReceiverToken(message);
          }
        });
        print('Document does not exist on the database');
      }

      // sendMessages(discussion, message);
    });
  }

  // checkIfIsFirstMessage(DiscussionModel discussion){

  //       FirebaseFirestore.instance
  //           .collection("Users")
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .collection("Conversations")
  //           .where("user1", isEqualTo: "sjfhdfjhdjfhsjhfdsjks")
  //           .get()
  //           .then(
  //         (value) {
  // if (value.size < 1) {
  //   // DiscussionModel discussion = new DiscussionModel(
  //   //     // admin: "",
  //   //     lastestMessage: "",
  //   //     latestProvider: "",
  //   //     isLastMessageHasBeenRead: false,
  //   //     creattionDateTime: Timestamp.now(),
  //   //     user1: widget.conversationModel.chatUsers.user.uid!,
  //   //     user2: FirebaseAuth.instance.currentUser!.uid);
  //             await FirebaseFirestore.instance
  //                 .collection("Users")
  //                 .doc(FirebaseAuth.instance.currentUser!.uid)
  //                 .collection("Conversations")
  //                 .add({discussion.toMap()}).then((value) => print(value));
  //           }else{

  //           }
  //         },
  //       );
  // }
}
