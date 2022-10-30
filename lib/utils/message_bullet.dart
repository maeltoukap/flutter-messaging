import 'package:flutter/material.dart';

class MessageBullet extends StatelessWidget {
  MessageBullet({Key? key, required this.provider, required this.message})
      : super(key: key);
  String provider;
  String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          provider == "me" ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: provider == "me" ? Colors.lightBlueAccent : Colors.brown,
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          message.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
