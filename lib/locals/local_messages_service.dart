import 'package:sqflite/sqflite.dart';
import 'package:wordpress_app/models/message.dart';

Database? database;

class LocalMessageServices {
  Message message;
  bool hasBeenSend;
  // bool hasBeen
  LocalMessageServices({
    required this.message,
    required this.hasBeenSend,
  });

  onOpenDB(String path) async {
    // final localDB = openDatabase(join(await getDatabasesPath(), 'chat.db'));

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Messages (id INTEGER PRIMARY KEY, provider TEXT, sendDateTime TEXT, hasBeenRead BOOLEAN, senderUid TEXT, receiverUid TEXT, containFiles BOOLEAN, fileUrl TEXT, groupDateTime INTEGER, groupDateTime TEXT)');
    });
  }

  onInsertData() async {
    await database!.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });
  }
}
