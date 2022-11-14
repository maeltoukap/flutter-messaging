import 'package:hive/hive.dart';
import 'package:wordpress_app/hive/hive_message.dart';
import 'package:wordpress_app/locals/local_messages_service.dart';

class Boxes {
  static Box<LocalMessageModel> getMessages() =>
      Hive.box<LocalMessageModel>("Messages");
}
