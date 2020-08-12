import 'package:flutter/material.dart';
import 'package:xlo/common/custom_drawer/custom_drawer.dart';

import 'account_edit.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Minha conta"),
        actions: <Widget>[
          FlatButton(
            child: const Text("EDITAR"),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditAccount(),
              ));
            },
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Deovan Zanol",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            title: Text(
              "Meus anuncios",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          ListTile(
            title: Text("Favoritos",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
            trailing: Icon(Icons.keyboard_arrow_right),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ),
    );
  }
}
