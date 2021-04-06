import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final tableName = "contacts";
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
      await db.execute('''CREATE TABLE $tableName
        (
          $idColumn INTEGER PRIMARY KEY,
          $nameColumn TEXT,
          $emailColumn TEXT,
          $phoneColumn TEXT,
          $imgColumn TEXT
      )''');
    });
  }
}
