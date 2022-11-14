import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress_app/models/message.dart';
import 'package:wordpress_app/models/user_model.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController textEditingController = TextEditingController();
  String messageValue = "";
  String receiverToken = "";
  String receiverUid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiverUid = widget.user.uid!;
  }
  // bool readyToSend = false;

  void getReceiverToken(Message message) {
    print("uidfinction: " + receiverUid);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(message.receiverUid.trim())
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data()! as Map<String, dynamic>;
      receiverToken = data["fcmToken"];
      setNotification(receiverToken, message);
      print(value.exists);
      // return data["fcmToken"];
    });
    // print(user);
    // return receiverToken;
  }

  sendMessages(Message message, String token) {
    // _messages.clear();
    // print("nvkdfjkdjfkd" + message.senderUid.trim());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(message.senderUid.trim())
        .collection("Messages")
        .add(message.toMap());
    // messages.add(message.toMap());
    // print(messages.length);
    // notifyListeners();

    message.provider = "external";
    FirebaseFirestore.instance
        .collection('Users')
        .doc(message.receiverUid.trim())
        .collection("Messages")
        .add(message.toMap())
        .then((value) {
      getReceiverToken(message);
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
        'sender': 'Mael Toukap',
        'message': message.message!
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                onChanged: (value) {
                  messageValue = value;
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),

          // Send Message Button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  // final ms = context.read<MessagesBloc>();
                  final fcmToken = await FirebaseMessaging.instance.getToken();
                  print(fcmToken);
                  textEditingController.text = "";
                  String _receiver = widget.user.uid!;
                  // getReceiverToken(receiverUid);
                  Message msg = Message(
                      hasBeenRead: false,
                      provider: "me",
                      // receiverFCM: receiverToken,
                      senderUid: "Fuggoi5F2jefEb9s6gjg",
                      receiverUid: widget.user.uid!.trim(),
                      message: messageValue,
                      containFiles: false,
                      fileUrl: "",
                      sendDateTime: Timestamp.now());
                  print(widget.user.uid);
                  // print(msg.message);
                  // getReceiverToken();
                  sendMessages(msg, receiverToken);
                  // ms.sendMessages(msg);
                  print("uid r " + _receiver);
                  // getReceiverToken(_receiver);
                  // print("Messages: " + ms.messages.toString());
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
