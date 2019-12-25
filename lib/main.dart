import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'show_code.dart';
import 'dart:convert';

class SWINFO {
  final String name;
  final String hair_skin;

  SWINFO({this.name, this.hair_skin});

  factory SWINFO.fromJson(Map<String, dynamic> json) {
    return SWINFO(name: json['name'], hair_skin: json['hair_skin']);
  }
}

class TestHttp extends StatefulWidget {
  final String url;

  TestHttp({String url}) : url = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  String _url;
  SWINFO _swinfo;

  @override
  void initState() {
    _url = widget.url;
    super.initState();
  } //initState

  _sendRequestGet() {
    http.get(_url).then((response) {
      _swinfo = SWINFO.fromJson(json.decode(response.body));

      setState(() {});
    }).catchError((error) {
      _swinfo = SWINFO(
        name: '',
        hair_skin: '',
      );
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    print(_swinfo.name);
    print(_swinfo.hair_skin);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                child: Text('API url',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                padding: EdgeInsets.all(10.0)),
            Container(
                child: TextFormField(
                    initialValue: _url,
                    validator: (value) {
                      if (value.isEmpty) return 'API url isEmpty';
                    },
                    onSaved: (value) {
                      _url = value;
                    },
                    autovalidate: true),
                padding: EdgeInsets.all(10.0)),
            SizedBox(height: 20.0),
            RaisedButton(
                child: Text('Send request GET'), onPressed: _sendRequestGet),
            Text('Response body',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            Text(_swinfo == null ? '' : _swinfo.name),
            Text(_swinfo == null ? '' : _swinfo.hair_skin),
          ],
        )));
  } //build
} //TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.code),
                tooltip: 'Code',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CodeScreen()));
                })
          ],
        ),
        body: TestHttp(url: 'https://swapi.co/api/people/1/'));
  }
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
