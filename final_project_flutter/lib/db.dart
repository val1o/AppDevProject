import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Mydb{
  late Database db; //Open that database for storing data

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'records4.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {

          await db.execute('''
            create table if not exists records (
            rid INTEGER PRIMARY KEY autoincrement,
            name varchar(50) not null,
            status int not null,
            date INTEGER,
            client_id int null,
            FOREIGN KEY (client_id) REFERENCES clients (cid)
              ON DELETE NO ACTION ON UPDATE NO ACTION
            )            
            ''');

          await db.execute('''
            create table if not exists clients (
            cid INTEGER PRIMARY KEY autoincrement,
            first_name varchar(50) not null,
            last_name varchar(50) not null,
            address varchar(50) not null,
            record_id int null,
            FOREIGN KEY (record_id) REFERENCES records (rid)
              ON DELETE CASCADE ON UPDATE NO ACTION
            )
            ''');

          await db.execute('''
            create table if not exists users (
            uid INTEGER PRIMARY KEY autoincrement,
            name varchar(50) not null,
            username varchar(50) not null unique,
            password varchar(50) not null
            )
            ''');
        }
    );
  }

  Future<Map<dynamic, dynamic>?> getRecord(String name) async {
    List<Map> maps =
    await db.query('records', where: 'name = ?', whereArgs: [name]);
    //Get record with appropriate id
    if(maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> getClient(String address) async {
    List<Map> maps =
    await db.query('clients', where: 'address = ?', whereArgs: [address]);
    //Get record with appropriate id
    if(maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> getUser(String username) async {
    List<Map> maps =
    await db.query('users', where: 'username = ?', whereArgs: [username]);
    // getting student with roll no
    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }
}

