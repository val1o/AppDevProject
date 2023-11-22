import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Mydb{
  late Database db; //Open that database for storing data

  Future open() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'records.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table if not exists records (
            rid primary key,
            roll_no int not null,
            name varchar(50) not null,
            status int not null,
            date int
            );            
            ''');
        }
    );
  }

  Future<Map<dynamic, dynamic>?> getRecord(int rollno) async {
    List<Map> maps =
    await db.query('records', where: 'roll_no = ?', whereArgs: [rollno]);
    //Get record with appropriate id
    if(maps.length > 0) {
      return maps.first;
    }
    return null;
  }
}