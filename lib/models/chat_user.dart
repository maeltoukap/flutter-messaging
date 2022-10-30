import 'package:wordpress_app/models/user_model.dart';

class ChatUsers {
  // String uid;
  // String name;
  // String userToken;
  UserModel user;
  String messageText;
  String imageURL;
  String time;
  ChatUsers(
      {
      //   required this.uid,
      // required this.name,
      required this.user,
      required this.messageText,
      required this.imageURL,
      required this.time});
}
