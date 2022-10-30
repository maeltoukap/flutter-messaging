import 'package:wordpress_app/models/chat_message.dart';
import 'package:wordpress_app/models/chat_user.dart';

class ConversationModel {
  ChatUsers chatUsers;
  List<ChatMessage> messages;

  ConversationModel({required this.chatUsers, required this.messages});
}
