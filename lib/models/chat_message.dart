import 'package:wordpress_app/models/chat_user.dart';

class ChatMessage {
  // ChatUsers chatUser;
  String messageContent;
  String messageType;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      // required this.chatUser,
      });
}
