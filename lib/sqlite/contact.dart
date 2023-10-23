import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';


final String databaseName = 'demo.db';
final String tableContact = 'contact';
final String columnId = '_id';
final String columnFullName = 'fullname';
final String columnPhone = 'phone';

class Contact {
  int? id;
  String fullName = "";
  String phone = "";

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnFullName: fullName,
      columnPhone: phone
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Contact();

  Contact.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId];
    fullName = map[columnFullName];
    phone = map[columnPhone];
  }
}

class ContactProvider {

  bool isInitialized = false;
  Database? db;





  Future<Database> open() async {

    WidgetsFlutterBinding.ensureInitialized();
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableContact ( 
            $columnId integer primary key autoincrement, 
            $columnFullName varchar(255) not null,
            $columnPhone varchar(255) not null)
          ''');
    });
  }

  Future<Contact> insert(Contact contact) async {
    db = await open();
    contact.id = await db!.insert(tableContact, contact.toMap());
    await close();
    return contact;
  }

  Future<Contact?> getContact(int id) async {
    db = await open();
    List<Map> maps = await db!.query(tableContact,
        columns: [columnId, columnPhone, columnFullName],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }
  Future<List<Contact>> getAllContact() async {
    List<Contact> contacts = [];
    db = await open();
    List<Map> maps = await db!.query(tableContact,
        columns: [columnId, columnPhone, columnFullName],
    );
    await close();
    if (maps.length > 0) {
      maps.forEach((element) {
        contacts.add(Contact.fromMap(element));
      });
    }
    return contacts;
  }

  Future<int> delete(int id) async {
    db = await open();
    int result = await db!.delete(tableContact, where: '$columnId = ?', whereArgs: [id]);
    await close();
    return result;
  }

  Future<int> update(Contact contact) async {
    int result = await db!.update(tableContact, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
    await close();
    return result;
  }

  Future close() async => db!.close();
}