import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:seek_for_sweetness/bluetooth_connection/connect.dart';
import 'package:seek_for_sweetness/database/db_manager.dart';
import 'package:seek_for_sweetness/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tflite/tflite.dart';
import 'component_UI.dart';
import 'dart:convert';
import 'package:path/path.dart';

// Data page
class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List appleData = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getData() async {
    TodoProvider todoProvider = TodoProvider();

    /// 通过getDatabasesPath()方法获取数据库位置
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "appleData.db");

    /// 打开数据库，并创建todo表
    await todoProvider.open(path);

    List<Map> tmp = await todoProvider.getAllTodo();
    List<Map> data = [];
    for (var _item in tmp) {
      data.add({
        'title': _item['result'],
        'subtitle_1': _item['date'],
        'subtitle_2': _item['kind']
      });
    }

    Provider.of<AppleData>(this.context, listen: false).update(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title:
                Text('Data', style: GoogleFonts.getFont('Lato', fontSize: 30))),
        body: Column(
          children:
              generatorDataCard(Provider.of<AppleData>(context).data, context),
        ));
  }
}

//About page.
class AboutPage extends StatelessWidget {
  // Maintain the list of open source licenses.
  final List _opensource = [
    {
      'title': 'Flutter - Google',
      'subtitle_1': 'http://flutter.dev',
      'subtitle_2': 'Apache 2.0',
      'leading': Icons.looks_one
    },
    {
      'title': 'AndroidX - Google',
      'subtitle_1': 'http://source.google.com',
      'subtitle_2': 'Apache 2.0',
      'leading': Icons.looks_two
    }
  ];

  // Generate the widget list based on the list above.

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outlined,
                size: 100,
              ),
              Container(
                child: Text('v0.0.1',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont('Lato')),
              )
            ],
          ),
        ),
        toolbarHeight: 250,
      ),
      body: ListView(
        children: [
              Container(
                child: Text(
                  "What's this",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
              ),
              SizedBox(
                height: 70,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8.0, 4.0, 0.0, 0.0),
                    child: Text(
                      "This is an app for our Optoelectronic Applications Experiments.",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ),
                  elevation: 1.0,
                  margin: EdgeInsets.all(4.0),
                ),
              ),
              Container(
                child: Text(
                  "Developer",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
              ),
              SizedBox(
                height: 70,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('Jinquan Shi',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text('https://github.com/2377671184'),
                    leading: Icon(
                      Icons.person_outline_rounded,
                      size: 30,
                    ),
                  ),
                  elevation: 1.0,
                  margin: EdgeInsets.all(4.0),
                ),
              ),
              Container(
                child: Text(
                  "Open Source Licenses",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                padding: EdgeInsets.fromLTRB(12.0, 8.0, 0, 8.0),
              ),
            ] +
            generator(_opensource),
      ),
    );
  }
}

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  FlutterBlue flutterBlue;
  @override
  void initState() {
    super.initState();
    flutterBlue = FlutterBlue.instance;
    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
      } else if (state == BluetoothState.off) {
        Fluttertoast.showToast(msg: 'Please open bluetooth!!!!');
      }
    });
  }

  //TODO: Find a way to safely disconnect the device.
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  Future<void> disconnect() async {
    var _devices = await flutterBlue.connectedDevices;
    for (var _device in _devices) {
      _device.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    flutterBlue.startScan(timeout: Duration(seconds: 2));

    flutterBlue.stopScan();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 120,
              ),
              Text(
                'Devices',
                style: GoogleFonts.getFont('Lato', fontSize: 40),
                textAlign: TextAlign.left,
              )
            ],
          ),
          toolbarHeight: 200,
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: [],
                  builder: (c, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return Column(
                        children: snapshot.data.map(
                          (r) {
                            return listWidget(r, this.context);
                          },
                        ).toList(),
                      );
                    } else
                      return null;
                  }),
            ],
          ),
        ));
  }
}

class MeasurePage extends StatefulWidget {
  @override
  _MeasurePageState createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {
  var recognitions;
  List msg;
  @override
  void initState() {
    super.initState();

    loadModel();
  }

  @override
  void dispose() {
    tfDispose();
    super.dispose();
  }

  Future<void> tfDispose() async {
    await Tflite.close();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }

  @override
  Widget build(BuildContext buildcontext) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<AppleData>(this.context, listen: false).getData();
        Navigator.pop(this.context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 120,
              ),
              Text(
                'Measure',
                style: GoogleFonts.getFont('Lato', fontSize: 40),
                textAlign: TextAlign.left,
              )
            ],
          ),
          toolbarHeight: 200,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: 300 / controller.value.aspectRatio,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: new Border.all(width: 1, color: Colors.white),
                    ),
                    child: ClipRRect(
                      child: CameraPreview(controller),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                                child: Text('Capture'),
                                onPressed: () async {
                                  XFile file = await controller.takePicture();
                                  await file.saveTo(file.path);
                                  recognitions = await Tflite.runModelOnImage(
                                      path: file.path, // required
                                      imageMean: 0.0, // defaults to 117.0
                                      imageStd: 255.0, // defaults to 1.0
                                      numResults: 2, // defaults to 5
                                      threshold: 0.2, // defaults to 0.1
                                      asynch: true // defaults to true
                                      );
                                  msg = recognitions[0]['label']
                                      .toString()
                                      .split(' ');
                                  msg.removeAt(0);
                                  msg.removeLast();
                                  Provider.of<BLEMsg>(buildcontext,
                                          listen: false)
                                      .getAppleKind(msg[0]);
                                  setState(() {});
                                }),
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Text('Measure'),
                              onPressed: () async {
                                for (var _item in Provider.of<BLEMsg>(
                                        buildcontext,
                                        listen: false)
                                    .characteristics) {
                                  await _item.write(utf8.encode('START'));
                                }
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Text('Save'),
                              onPressed: () async {
                                Provider.of<BLEMsg>(buildcontext, listen: false)
                                    .saveTree();
                              },
                            ),
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                                child: Text('Main'),
                                onPressed: () async {
                                  Provider.of<AppleData>(buildcontext,
                                          listen: false)
                                      .getData();
                                  Navigator.of(buildcontext).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()),
                                      (route) => route == null);
                                }),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                      width: 200,
                      child: Text(
                          'Type : ' + Provider.of<BLEMsg>(buildcontext).kind)),
                  Text('Result: ' + Provider.of<BLEMsg>(buildcontext).result),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
