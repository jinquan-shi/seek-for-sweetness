import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seek_for_sweetness/UI/pages_UI.dart';
import 'package:seek_for_sweetness/bluetooth_connection/connect.dart';

List<CameraDescription> cameras;
CameraController controller;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BLEMsg>(create: (_) => BLEMsg()),
      ChangeNotifierProvider<AppleData>(create: (_) => AppleData()),
    ],
    child: MyApp(),
  ));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  List<Widget> _pageItems = [
    DataPage(),
    AboutPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: _pageItems,
      ),
      bottomNavigationBar: SizedBox(
        height: 52,
        child: Material(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            tabs: <Tab>[
              Tab(icon: Icon(Icons.data_usage_rounded)),
              Tab(icon: Icon(Icons.info_outline)),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicator: const BoxDecoration(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 36,
        ),
        onPressed: _pressMeasure,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Measure.
  void _pressMeasure() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new DevicesPage(
                  title: 'The second page.',
                )));
  }
}
