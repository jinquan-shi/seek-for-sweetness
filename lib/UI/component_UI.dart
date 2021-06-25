import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:seek_for_sweetness/bluetooth_connection/connect.dart';
import 'package:seek_for_sweetness/database/db_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pages_UI.dart';

// Items in the bottom bar
final List<BottomNavigationBarItem> bottomNavBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.data_usage_rounded),
    label: 'Data',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.info_outline_rounded),
    label: 'About',
  ),
];

//Generate a list of cards from a list.
List<Widget> generator(dataList) {
  List<Widget> list = [];
  if (dataList.isEmpty == false) {
    for (var _item in dataList) {
      list.add(
        SizedBox(
          height: 70,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(_item['title'],
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(_item['subtitle_1'] + '\n' + _item['subtitle_2']),
              leading: Icon(
                _item['leading'],
                size: 30,
              ),
            ),
            elevation: 1.0,
            margin: EdgeInsets.all(4.0),
          ),
        ),
      );
    }
    return list;
  } else {
    return [];
  }
}

//Generate a list of cards from a list.
List<Widget> generatorDataCard(dataList, BuildContext context) {
  List<Widget> list = [];
  if (dataList.isEmpty == false) {
    for (var _item in dataList) {
      list.add(
        SizedBox(
          height: 70,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(_item['title'].toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(_item['subtitle_1'] + '\n' + _item['subtitle_2']),
              leading: Icon(
                _item['leading'],
                size: 30,
              ),
              trailing: ElevatedButton(
                child: Icon(
                  Icons.delete_forever_outlined,
                ),
                onPressed: () async {
                  TodoProvider todoProvider = TodoProvider();

                  /// 通过getDatabasesPath()方法获取数据库位置
                  var databasePath = await getDatabasesPath();
                  String path = join(databasePath, "appleData.db");

                  /// 打开数据库，并创建todo表
                  await todoProvider.open(path);

                  await todoProvider.delete(_item['subtitle_1']);

                  Provider.of<AppleData>(context, listen: false).getData();
                },
              ),
            ),
            elevation: 1.0,
            margin: EdgeInsets.all(4.0),
          ),
        ),
      );
    }
    return list;
  } else {
    return [];
  }
}

// Item for the bluetooth device list
Widget listWidget(item, BuildContext context) {
  BluetoothDevice _device = item.device;
  if (_device.name != '') {
    return SizedBox(
      height: 80,
      child: GestureDetector(
        onTap: () async {
          Future.delayed(Duration(milliseconds: 000)).then((_) async {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => MeasurePage()));
            await handleRow(item, context);
          });
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(_device.name,
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(_device.id.toString() + '\n' + item.rssi.toString()),
            leading: Icon(
              Icons.device_unknown_outlined,
              size: 30,
            ),
          ),
          elevation: 1.0,
          margin: EdgeInsets.all(4.0),
        ),
      ),
    );
  } else
    return Container();
}

Future<void> handleRow(item, BuildContext context) async {
  BluetoothDevice device = item.device;
  try {
    await device.connect(); // Connect the device.
    //await device.requestMtu(20);
  } on Exception catch (e) {
    EasyLoading.dismiss();
    print('Error in connection!!!!!!!!!');
    print(e);
    return false;
  }

  // Set cache of my BLE list.
  // setMyBleList(item);

  //
  // Acquire the list of bluetooth services.
  List<BluetoothService> services = await device.discoverServices();
  BluetoothService serviceObj;
  // Tranverse the list.
  services.forEach((service) {
    serviceObj = service;
  });

  __belCharacteristics(device, serviceObj, context);
}

setNotifyValue(device, BluetoothCharacteristic characteristics,
    BuildContext context) async {
  // Set up a subscription.
  if (characteristics.properties.notify & !characteristics.isNotifying) {
    try {
      await characteristics.setNotifyValue(true);
    } catch (e) {
      print('');
    }
  }

  var ble = Provider.of<BLEMsg>(context, listen: false);
  // The subscription callback.
  characteristics.value.listen((List<int> value) async {
    print('----Data returned------');
    try {
      // var tmp = json.decode(String.fromCharCodes(value));
      Provider.of<BLEMsg>(context, listen: false).read(value);
      //Provider.of<AppleData>(context, listen: false).getData();
      if (ble.sendMsg != '') {
        await characteristics.write(utf8.encode('START'));
        ble.sendMsg = '';
      }
    } on Exception catch (e) {
      print(e);
    }
  });
}

__belCharacteristics(BluetoothDevice device, BluetoothService serviceObj,
    BuildContext context) async {
  // Acquire the uuid.
  List<BluetoothCharacteristic> characteristics = serviceObj.characteristics;
  Provider.of<BLEMsg>(context, listen: false).newConnection(characteristics);
  for (var _item in characteristics) {
    if (_item.deviceId == device.id) if (_item.properties.notify) {
      await setNotifyValue(device, _item, context);
    }
  }
}
