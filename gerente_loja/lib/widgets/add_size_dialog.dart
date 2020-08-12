import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 24, right: 24),
      title: Text("Preencha o tamanho"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _controller,
          ),
        ],
      ),
      actions: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("Add"),
                textColor: Colors.pinkAccent,
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
