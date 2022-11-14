import 'package:sqflite/sqflite.dart';
import 'package:wordpress_app/models/message.dart';

class DatabaseLocalStorage {
  static final DatabaseLocalStorage instance = DatabaseLocalStorage._init();

  static Database? _database;

  DatabaseLocalStorage._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    // final path = join(dbPath, filePath);
    return await openDatabase("path", version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableMessage( ${MessageFields.id} $idType, 
${MessageFields.provider} $textType, 
${MessageFields.hasBeenRead} $boolType,
${MessageFields.message} $textType,
${MessageFields.senderUid} $textType,
${MessageFields.receiverUid} $textType,
${MessageFields.containsFiles} $boolType,
${MessageFields.fileUrl} $textType,
${MessageFields.groupDataTime} $textType)
''');
  }

  Future<Message> create(Message message) async {
    final db = await instance.database;
    final id = await db.insert(tableMessage, message.toMapForLocal());
    return message.copy(id: id);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
