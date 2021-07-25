import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:seek_for_sweetness/database/db_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'RF.dart';

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
      inferenceRF(data);
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

  double calculateTree(Map<String, dynamic> data) {
    double _value;
    if (this.kind == 'Golden') {
      // if (int.parse(data['LED1']) < 743) {
      //   if (int.parse(data['LED2']) < 820) {
      //     if (int.parse(data['LED1']) < 654.5) {
      //       if (int.parse(data['LED5']) < 748.5) {
      //         _value = 14.36;
      //       } else {
      //         _value = 13.4393;
      //       }
      //     } else {
      //       _value = 12.0452;
      //     }
      //   } else {
      //     if (int.parse(data['LED1']) < 699) {
      //       _value = 14.4556;
      //     } else {
      //       if (int.parse(data['LED4']) < 724.5) {
      //         _value = 14.1886;
      //       } else {
      //         _value = 13.6071;
      //       }
      //     }
      //   }
      // } else {
      //   if (int.parse(data['LED6']) < 959) {
      //     _value = 11.7886;
      //   } else {
      //     if (int.parse(data['LED3']) < 792.5) {
      //       if (int.parse(data['LED1']) < 851) {
      //         _value = 13.2106;
      //       } else {
      //         _value = 12.0377;
      //       }
      //     } else {
      //       if (int.parse(data['LED5']) < 883) {
      //         _value = 14.0473;
      //       } else {
      //         _value = 12.7545;
      //       }
      //     }
      //   }
      // }

      if (int.parse(data['LED4']) < 595) {
        _value = 13.58;
      } else {
        if (int.parse(data['LED4']) < 661.5) {
          _value = 12.0971;
        } else {
          if (int.parse(data['LED2']) < 817) {
            _value = 12.5548;
          } else {
            if (int.parse(data['LED1']) < 762.5) {
              if (int.parse(data['LED1']) < 734) {
                if (int.parse(data['LED4']) < 726)
                  _value = 13.4629;
                else
                  _value = 13.6657;
              } else
                _value = 13.3143;
            } else {
              if (int.parse(data['LED6']) < 971) {
                _value = 13.4959;
              } else {
                if (int.parse(data['LED4']) < 696) {
                  _value = 12.2629;
                } else {
                  if (int.parse(data['LED5']) < 878.5) {
                    if (int.parse(data['LED3']) < 793.5)
                      _value = 12.9314;
                    else
                      _value = 13.5786;
                  } else
                    _value = 12.7702;
                }
              }
            }
          }
        }
      }
    } else {
      // Tree v0.1
      // if (int.parse(data['LED5']) < 837) {
      //   if (int.parse(data['LED5']) < 786.5) {
      //     _value = 12.2445;
      //   } else {
      //     if (int.parse(data['LED4']) < 668.5) {
      //       if (int.parse(data['LED2']) < 821) {
      //         _value = 12.4057;
      //       } else {
      //         _value = 13.1257;
      //       }
      //     } else {
      //       if (int.parse(data['LED5']) < 811) {
      //         _value = 14.0743;
      //       } else {
      //         if (int.parse(data['LED6']) < 978.5)
      //           _value = 13.5119;
      //         else
      //           _value = 12.85;
      //       }
      //     }
      //   }
      // } else {
      //   if (int.parse(data['LED4']) < 690.5) {
      //     _value = 13.4554;
      //   } else {
      //     if (int.parse(data['LED2']) < 874.5)
      //       _value = 14.3486;
      //     else
      //       _value = 15.3857;
      //   }
      // }

      if (int.parse(data['LED1']) < 901.5) {
        if (int.parse(data['LED6']) < 974.5) {
          if (int.parse(data['LED4']) < 719.5) {
            if (int.parse(data['LED1']) < 856.5) {
              if (int.parse(data['LED2']) < 813.5)
                _value = 12.948;
              else
                _value = 13.4419;
            } else
              _value = 12.7024;
          } else
            _value = 14.1457;
        } else {
          if (int.parse(data['LED4']) < 680) {
            if (int.parse(data['LED6']) < 980.5)
              _value = 12.7286;
            else
              _value = 12.2457;
          } else {
            if (int.parse(data['LED4']) < 733) {
              if (int.parse(data['LED4']) < 724.5)
                _value = 13.1054;
              else
                _value = 12.5943;
            } else
              _value = 13.2714;
          }
        }
      } else {
        if (int.parse(data['LED3']) < 779)
          _value = 14.0405;
        else
          _value = 13.4829;
      }
    }

    return _value;
  }

  double calculate(Map<String, dynamic> data) {
    double _value;
    List _golden = [
      8.56517706013540,
      -0.00237079159353689,
      -0.00378366395991100,
      0.00543097160081538,
      -0.00700401540758357,
      -0.000117260477541749,
      0.0110929602732095,
      27.4611516717532,
      0.00121667878576689,
      -0.00498128052265754,
      0.00839331493838024,
      0.00558714824163215,
      0.0204749627503553,
      -0.0386803716912721
    ];

    List _red = [
      27.4611516717532,
      0.00121667878576689,
      -0.00498128052265754,
      0.00839331493838024,
      0.00558714824163215,
      0.0204749627503553,
      -0.0386803716912721
    ];

    if (this.kind == 'Golden') {
      _value = _golden[0] +
          // _golden[1] * int.parse(data['LED1']) +
          // _golden[2] * int.parse(data['LED2']) +
          // _golden[3] * int.parse(data['LED3']) +
          // _golden[4] * int.parse(data['LED4']) +
          // _golden[5] * int.parse(data['LED5']) +
          // _golden[6] * int.parse(data['LED6'])+
          _golden[7] * log(int.parse(data['LED1'])) / log(10) +
          _golden[8] * log(int.parse(data['LED2'])) / log(10) +
          _golden[9] * log(int.parse(data['LED3'])) / log(10) +
          _golden[10] * log(int.parse(data['LED4'])) / log(10) +
          _golden[11] * log(int.parse(data['LED5'])) / log(10) +
          _golden[12] * log(int.parse(data['LED6'])) / log(10);
      // _golden[13] / int.parse(data['LED1']) +
      // _golden[14] / int.parse(data['LED2']) +
      // _golden[15] / int.parse(data['LED3']) +
      // _golden[16] / int.parse(data['LED4']) +
      // _golden[17] / int.parse(data['LED5']) +
      // _golden[18] / int.parse(data['LED6']);

    } else {
      _value = _red[0] +
          _red[1] * int.parse(data['LED1']) +
          _red[2] * int.parse(data['LED2']) +
          _red[3] * int.parse(data['LED3']) +
          _red[4] * int.parse(data['LED4']) +
          _red[5] * int.parse(data['LED5']) +
          _red[6] * int.parse(data['LED6']);
      // _red[7] * log(int.parse(data['LED1'])) / log(10) +
      // _red[8] * log(int.parse(data['LED2'])) / log(10) +
      // _red[9] * log(int.parse(data['LED3'])) / log(10) +
      // _red[10] * log(int.parse(data['LED4'])) / log(10) +
      // _red[11] * log(int.parse(data['LED5'])) / log(10) +
      // _red[12] * log(int.parse(data['LED6'])) / log(10) +
      // _red[13] / int.parse(data['LED1']) +
      // _red[14] / int.parse(data['LED2']) +
      // _red[15] / int.parse(data['LED3']) +
      // _red[16] / int.parse(data['LED4']) +
      // _red[17] / int.parse(data['LED5']) +
      // _red[18] / int.parse(data['LED6']);
    }

    return _value;
  }

  Future<void> inferenceTree(Map<String, dynamic> data) async {
    double _value = calculateTree(data);
    result = _value.toStringAsFixed(2);
    print(result);
    notifyListeners();
  }

  Future<void> inferenceRF(Map<String, dynamic> data) async {
    List<double> input = [];
    for (var value in data.values) {
      input.add(double.parse(value));
    }
    double _value = score(input);
    result = _value.toStringAsFixed(2);
    print(result);
    notifyListeners();
  }

  Future<void> saveTree() async {
    double _value = calculateTree(this.data);
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
