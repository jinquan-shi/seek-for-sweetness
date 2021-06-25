import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

querySQLHelper(Map<String, dynamic> datain, String kind, double result) async {
  TodoProvider todoProvider = TodoProvider();

  final data = Map.castFrom(datain);

  /// 通过getDatabasesPath()方法获取数据库位置
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, "appleData.db");

  /// 打开数据库，并创建todo表
  await todoProvider.open(path);

  Todo todo = Todo();
  todo.date = DateTime.now().toString();
  todo.kind = kind;
  todo.LED_1 = int.parse(data['LED1']);
  todo.LED_2 = int.parse(data['LED2']);
  todo.LED_3 = int.parse(data['LED3']);
  todo.LED_4 = int.parse(data['LED4']);
  todo.LED_5 = int.parse(data['LED5']);
  todo.LED_6 = int.parse(data['LED6']);
  todo.result = result;
  Todo td = await todoProvider.insert(todo);
  print(todoProvider);

  // /// 查一条数据
  // Todo todo = Todo();
  // todo.id = 1;
  // todo.kind = "Hello";
  // todo.LED_1 = 900;
  // Todo td = await todoProvider.insert(todo);
  // print('inserted:${td.toMap()}');

  // Todo todo2 = Todo();
  // todo2.id = 2;
  // todo2.kind = "Hello world";
  // todo2.LED_2 = 900;
  // Todo td2 = await todoProvider.insert(todo2);
  // print('inserted:${td2.toMap()}');

  // /// 更新数据
  // todo2.kind = "Big big world";
  // int u = await todoProvider.update(todo2);
  // print("update:$u");

  // /// 删除数据
  // int d = await todoProvider.delete(1);
  // print("delete:$d");

  // /// 查询数据
  // Todo dd = await todoProvider.getTodo(0);
  // print("todo:${dd.toMap()}");

  /// 关闭数据库
  //todoProvider.close();
}

/// 表名
final String tableTodo = 'todo';

/// _id字段
final String columnId = '_id';

final String columnDate = 'date';
final String columnKind = 'kind';
final String columnLED_1 = 'LED_1';
final String columnLED_2 = 'LED_2';
final String columnLED_3 = 'LED_3';
final String columnLED_4 = 'LED_4';
final String columnLED_5 = 'LED_5';
final String columnLED_6 = 'LED_6';
final String columnResult = 'result';

/// 操作todo表的工具类
class TodoProvider {
  var db;

  /// 打开数据库，并创建todo表
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableTodo ( 
  $columnDate text not null,
  $columnKind text not null,
  $columnLED_1 integer,
  $columnLED_2 integer,
  $columnLED_3 integer,
  $columnLED_4 integer,
  $columnLED_5 integer,
  $columnLED_6 integer,
  $columnResult decimal(2))
''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  // Future<Todo> getTodo(int id) async {
  //   List<Map<String, dynamic>> maps = await db.query(tableTodo,
  //       columns: [
  //         columnDate,
  //         columnKind,
  //         columnLED_1,
  //         columnLED_2,
  //         columnLED_3,
  //         columnLED_4,
  //         columnLED_5,
  //         columnLED_6,
  //         columnResult
  //       ],
  //       where: '$Id = ?',
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return Todo.fromMap(maps.first);
  //   }

  //   return Todo();
  // }

  Future<List<Map>> getAllTodo() async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableTodo');
    return list;
  }

  Future<int> delete(String date) async {
    return await db
        .delete(tableTodo, where: '$columnDate = ?', whereArgs: [date]);
  }

  // Future<int> update(Todo todo) async {
  //   return await db.update(tableTodo, todo.toMap(),
  //       where: '$columnId = ?', whereArgs: [todo.id]);
  // }

  Future close() async => db.close();
}

/// todo对应的实体类
class Todo {
  String date = '';
  String kind = '';
  int LED_1 = 1023;
  int LED_2 = 1023;
  int LED_3 = 1023;
  int LED_4 = 1023;
  int LED_5 = 1023;
  int LED_6 = 1023;
  double result = 0.0;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDate: date,
      columnKind: kind,
      columnLED_1: LED_1,
      columnLED_2: LED_2,
      columnLED_3: LED_3,
      columnLED_4: LED_4,
      columnLED_5: LED_5,
      columnLED_6: LED_6,
      columnResult: result
    };
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    kind = map[columnKind];
    date = map[columnDate];
    LED_1 = map[columnLED_1];
    LED_2 = map[columnLED_2];
    LED_3 = map[columnLED_3];
    LED_4 = map[columnLED_4];
    LED_5 = map[columnLED_5];
    LED_6 = map[columnLED_6];
    result = map[columnResult];
  }
}
