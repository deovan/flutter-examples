import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Contado de pessoas",
    home: Home(),
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = "Pode entrar";

  void _changedPeople(int delta) {
    setState(() {
      _people += delta;

      if (_people < 0) {
        _infoText = "Mundo invertido?";
      } else if (_people <= 10) {
        _infoText = "Pode entrar";
      } else {
        _infoText = "Lotado";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: Size.infinite.height,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas: $_people",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text(
                    "+1",
                    style: TextStyle(fontSize: 48.0, color: Colors.white),
                  ),
                  onPressed: () {
                    _changedPeople(1);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                  child: Text(
                    "-1",
                    style: TextStyle(fontSize: 48.0, color: Colors.white),
                  ),
                  onPressed: () {
                    _changedPeople(-1);
                  },
                ),
              ),
            ]),
            Text(
              "$_infoText",
              style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ],
    );
  }
}
