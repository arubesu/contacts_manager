import 'package:contacts_manager/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final contactsTableName = "contacts";
final idColumn = "id";
final nameColumn = "name";
final emailColumn = "email";
final phoneColumn = "phone";
final imgColumn = "img";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper._getInstance();

  factory ContactHelper() => _instance;

  ContactHelper._getInstance();

  Database _db;

  Future<Database> get db async => _db != null ? _db : await _initDb();

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final fullPath = join(databasePath, 'contacts.db');

    return await openDatabase(fullPath, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute('''CREATE TABLE $contactsTableName
        (
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
      )''');
    });
  }

  Future<Contact> saveOrUpdateContact(Contact contact) async {
    var dbContact = await db;

    contact.id = await dbContact.insert(contactsTableName, contact.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return contact;
  }

  Future<Contact> getContact(int id) async {
    var dbContact = await db;

    var contacts = await dbContact.query(contactsTableName,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (contacts.length > 0) {
      return Contact.fromMap(contacts.first);
    }

    return null;
  }

  Future<int> deleteContact(int id) async {
    var dbContact = await db;

    return await dbContact
        .delete(contactsTableName, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<List<Contact>> getContacts() async {
    var dbContact = await db;

    var contactsMap = await dbContact.query(contactsTableName);
    return contactsMap.map((contact) => Contact.fromMap(contact)).toList();
  }

  Future close() async {
    var dbContact = await db;
    dbContact.close();
  }
}
