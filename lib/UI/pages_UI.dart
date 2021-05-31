import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Data page
class DataPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
      ),
    );
  }

}

//About page.
class AboutPage extends StatelessWidget {
  // Maintain the list of open source licenses.
  final List _opensource = [
    {
      'name': 'flutter',
      'website': 'http://flutter.dev',
      'license': 'Apache 2.0',
      'icon': Icons.looks_one
    },
    {
      'name': 'AndroidX',
      'website': 'http://flutter.dev',
      'license': 'Apache 2.0',
      'icon': Icons.looks_two
    }
  ];

  // Generate the widget list based on the list above.
  List<Widget> _generator() {
    List<Widget> list = [];
    for (var _item in _opensource) {
      list.add(
        SizedBox(
          height: 70,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(_item['name'],
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(_item['website'] + '\n' + _item['license']),
              leading: Icon(
                _item['icon'],
                color: Colors.blue[500],
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
  }

  @override
  Widget build(BuildContext buildContext) {
    //TODO: Complete the about page.
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
                child: Text(
                  'v0.0.1',
                  textAlign: TextAlign.center,
                ),
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
                      color: Colors.blue[500],
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
            _generator(),
      ),
    );
  }
}
