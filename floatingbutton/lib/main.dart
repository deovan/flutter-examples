import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = const MethodChannel("floating_button");
  int count = 0;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) {
      if (call.method == "touch") {
        count += 1;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Floating Window"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '$count',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50),
            ),
            RaisedButton(
              child: Text("Create"),
              onPressed: () {
                platform.invokeMethod("create");
              },
            ),
            RaisedButton(
              child: Text("Show"),
              onPressed: () {
                platform.invokeMethod("show");
              },
            ),
            RaisedButton(
              child: Text("Hide"),
              onPressed: () {
                platform.invokeMethod("hide");
              },
            ),
            RaisedButton(
              child: Text("Verify"),
              onPressed: () {
                platform
                    .invokeMethod("isShowing")
                    .then((value) => print(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
