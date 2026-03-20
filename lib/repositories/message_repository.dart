import 'package:flutter_blog/models/message.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  static Future<Database> getDatabase() async {
    final database = await openDatabase(
      'contacts.db',
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            message TEXT NOT NULL,
            image_path TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE messages ADD COLUMN image_path TEXT');
        }
      },
    );
    return database;
  }

  static Future<List<Message>> getMessages() async {
    final db = await getDatabase();
    final result = await db.query('messages', orderBy: 'id DESC');
    return result.map((map) => Message.fromMap(map)).toList();
  }

  static Future<int> addMessage(Message message) async {
    final db = await getDatabase();
    final map = message.toMap()..remove('id');
    return await db.insert('messages', map);
  }

  static Future<int> updateMessage(Message message) async {
    final db = await getDatabase();
    return await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  static Future<int> deleteMessage(int id) async {
    final db = await getDatabase();
    return await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }
}
