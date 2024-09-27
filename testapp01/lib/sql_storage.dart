import 'package:sqflite/sqflite.dart';

const String tableCounter = 'counterTable';
const String columnId = '_id';
const String columnCounter = 'counter';

class CounterObject {
  late int id;
  late int counter;

  Map<String, dynamic> toMap() {
    var map = <String, Object?>{
      columnId: id,
      columnCounter: counter,
    };
    return map;
  }

  CounterObject();

  CounterObject.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    counter = map[columnCounter];
  }
}

class TSqlStorage {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableCounter ( 
  $columnId integer primary key autoincrement, 
  $columnCounter text not null,
''');
    });
  }

  Future<CounterObject> insert(CounterObject count) async {
    count.id = await db.insert(tableCounter, count.toMap());
    return count;
  }

  Future<CounterObject> getCounterObject(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableCounter,
        columns: [columnId, columnCounter],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return CounterObject.fromMap(maps.first);
    }
    CounterObject co = CounterObject();
    co.id = id;
    co.counter = 0;
    co = await insert(co);
    return co;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableCounter, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(CounterObject count) async {
    return await db.update(tableCounter, count.toMap(),
        where: '$columnId = ?', whereArgs: [count.id]);
  }

  Future close() async => db.close();
}