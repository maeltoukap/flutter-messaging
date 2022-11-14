import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wordpress_app/models/notification_model.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}


// void navigateToNotificationDetailsScreen (context, NotificationModel notificationModel){
//   if(notificationModel.postID == null){
//     nextScreen(context, CustomNotificationDeatils(notificationModel: notificationModel));
//   }else{
//     nextScreen(context, PostNotificationDetails(postID: notificationModel.postID!));
//   }
// }