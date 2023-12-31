import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


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

  static Database? db;

  Future<Database?> get open async {

    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    if(db == null){
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute('''
            create table $tableContact ( 
            $columnId integer primary key autoincrement, 
            $columnFullName varchar(255) not null,
            $columnPhone varchar(255) not null)
          ''');
          });
      return db ;
    }
    else{
      return db;
    }

  }

  Future<Contact> insert(Contact contact) async {
    db = await open;
    contact.id = await db!.insert(tableContact, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    db = await open;
    List<Map> maps = await db!.query(tableContact,
        columns: [columnId, columnPhone, columnFullName],
        where: '$columnId = ?',
        whereArgs: [id]);
    //if (maps.length > 0) {
        return Contact.fromMap(maps.first);
    //}
  }
  Future<List<Contact>> getAllContact() async {
    List<Contact> contacts = [];
    db = await open;
    List<Map> maps = await db!.query(tableContact,
      columns: [columnId, columnPhone, columnFullName],
    );
    if (maps.length > 0) {
      maps.forEach((element) {
        contacts.add(Contact.fromMap(element));
      });
    }
    return contacts;
  }

  Future<int> delete(int id) async {
    db = await open;
    int result = await db!.delete(tableContact, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> update(Contact contact) async {
    db = await open;
    int result = await db!.update(tableContact, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
    return result;
  }

  Future close() async => db!.close();
}
