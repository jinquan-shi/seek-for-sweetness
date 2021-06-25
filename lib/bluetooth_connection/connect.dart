import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:seek_for_sweetness/database/db_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BLEMsg extends ChangeNotifier {
  // The message
  String msg = '';
  String sendMsg = '';
  String result = '';
  List<BluetoothCharacteristic> characteristics;
  Map<String, dynamic> data = Map();
  bool _flag = false;
  bool inferable = false;
  String kind = '';
  void read(List<int> value) {
    msg = String.fromCharCodes(value);
    Map<String, dynamic> tmp = json.decode(msg);
    if (tmp.entries.toString() == {'msg': 'DATA'}.entries.toString()) {
      _flag = true;
      notifyListeners();
      return;
    } else if (tmp.entries.toString() ==
        {'msg': 'COMPLETED'}.entries.toString()) {
      _flag = false;
      print(data);
      inferenceTree(data);
      // Future.delayed(Duration(seconds: 2)).then((_) {
      //   data.clear();
      // });
    }
    if (_flag) {
      data.addAll(json.decode(msg));
    }
    // Notify the listener.
    notifyListeners();
  }

  void send(String text) {
    sendMsg = text;
    print(this.sendMsg);
    notifyListeners();
  }

  void newConnection(List<BluetoothCharacteristic> bluetooth) {
    this.characteristics = bluetooth;
    notifyListeners();
  }

  Future<void> inference(Map<String, dynamic> data) async {
    double _value = 23.7805790943611 -
        0.00289487819625315 * int.parse(data['LED1']) +
        0.000124493820037609 * int.parse(data['LED2']) +
        0.00482661175574884 * int.parse(data['LED3']) +
        0.00361513118548979 * int.parse(data['LED4']) +
        0.00113251177887642 * int.parse(data['LED5']) +
        -0.0138091328667614 * int.parse(data['LED6']);
    result = _value.toStringAsFixed(2);
    print(result);
    notifyListeners();
  }

  Future<void> save() async {
    var data = this.data;
    double _value = 23.7805790943611 -
        0.00289487819625315 * int.parse(data['LED1']) +
        0.000124493820037609 * int.parse(data['LED2']) +
        0.00482661175574884 * int.parse(data['LED3']) +
        0.00361513118548979 * int.parse(data['LED4']) +
        0.00113251177887642 * int.parse(data['LED5']) +
        -0.0138091328667614 * int.parse(data['LED6']);
    result = _value.toStringAsFixed(2);
    await querySQLHelper(data, this.kind, _value);
    print(result);
    Future.delayed(Duration(seconds: 1)).then((_) {
      this.data.clear();
    });
    notifyListeners();
  }

  double calculate(Map<String, dynamic> data) {
    double _value;
    if (this.kind == 'Golden') {
      if (int.parse(data['LED1']) < 743) {
        if (int.parse(data['LED2']) < 820) {
          if (int.parse(data['LED1']) < 654.5) {
            if (int.parse(data['LED5']) < 748.5) {
              _value = 14.36;
            } else {
              _value = 13.4393;
            }
          } else {
            _value = 12.0452;
          }
        } else {
          if (int.parse(data['LED1']) < 699) {
            _value = 14.4556;
          } else {
            if (int.parse(data['LED4']) < 724.5) {
              _value = 14.1886;
            } else {
              _value = 13.6071;
            }
          }
        }
      } else {
        if (int.parse(data['LED6']) < 959) {
          _value = 11.7886;
        } else {
          if (int.parse(data['LED3']) < 792.5) {
            if (int.parse(data['LED1']) < 851) {
              _value = 13.2106;
            } else {
              _value = 12.0377;
            }
          } else {
            if (int.parse(data['LED5']) < 883) {
              _value = 14.0473;
            } else {
              _value = 12.7545;
            }
          }
        }
      }
    } else {
      if (int.parse(data['LED5']) < 837) {
        if (int.parse(data['LED5']) < 786.5) {
          _value = 12.2445;
        } else {
          if (int.parse(data['LED4']) < 668.5) {
            if (int.parse(data['LED2']) < 821) {
              _value = 12.4057;
            } else {
              _value = 13.1257;
            }
          } else {
            if (int.parse(data['LED5']) < 811) {
              _value = 14.0743;
            } else {
              if (int.parse(data['LED6']) < 978.5)
                _value = 13.5119;
              else
                _value = 12.85;
            }
          }
        }
      } else {
        if (data['LED4'] < 690.5) {
          _value = 13.4554;
        } else {
          if (data['LED2'] < 874.5)
            _value = 14.3486;
          else
            _value = 15.3857;
        }
      }
    }

    return _value;
  }

  Future<void> inferenceTree(Map<String, dynamic> data) async {
    double _value = calculate(data);
    result = _value.toStringAsFixed(2);
    print(result);
    notifyListeners();
  }

  Future<void> saveTree() async {
    double _value = calculate(this.data);
    result = _value.toStringAsFixed(2);
    await querySQLHelper(data, this.kind, _value);
    print(result);
    Future.delayed(Duration(seconds: 1)).then((_) {
      this.data.clear();
    });
    notifyListeners();
  }

  void getAppleKind(String type) {
    this.kind = type;
  }
}

class AppleData extends ChangeNotifier {
  List<Map> data = [];

  void update(List<Map> data) {
    this.data = data;
    notifyListeners();
  }

  Future<void> getData() async {
    TodoProvider todoProvider = TodoProvider();

    /// 通过getDatabasesPath()方法获取数据库位置
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "appleData.db");

    /// 打开数据库，并创建todo表
    await todoProvider.open(path);

    List<Map> tmp = await todoProvider.getAllTodo();

    data = [];
    for (var _item in tmp) {
      data.add({
        'title': _item['result'],
        'subtitle_1': _item['date'].toString(),
        'subtitle_2': _item['kind'].toString()
      });
    }
    notifyListeners();
  }
}
