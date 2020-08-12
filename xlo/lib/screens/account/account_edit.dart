import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xlo/models/user.dart';

import 'widgets/user_type_widget.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final User _user = User(name: "Deovan Zanol");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Editar Conta"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            UserTypeWidget(
              initialValue: _user.userType,
              onSaved: (newValue) {
                _user.userType = newValue;
              },
            ),
            TextFormField(
              decoration: _buildInputDecoration("Nome *"),
              initialValue: _user.name,
              validator: (value) {
                if (value.length < 6) return 'Nome inválido';
                return null;
              },
              onSaved: (newValue) {
                _user.name = newValue;
              },
            ),
            TextFormField(
              decoration: _buildInputDecoration("Telefone *"),
              initialValue: _user.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                TelefoneInputFormatter()
              ],
              validator: (value) {
                if (value.length < 15) return 'Telefone inválido';
                return null;
              },
              onSaved: (newValue) {
                _user.phone = newValue;
              },
            ),
            TextFormField(
              decoration: _buildInputDecoration("Nova senha"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return null;
                }
                if (value.length < 6) return 'Senha muito curta';
                return null;
              },
              autovalidate: true,
            ),
            TextFormField(
              decoration: _buildInputDecoration("Repita nova senha"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              autovalidate: true,
              validator: (value) {
                if (value.isEmpty) {
                  return null;
                }
                if (value.length < 6) return 'Senha muito curta';
                return null;
              },
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  "Salvar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  "Sair",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String nome) => InputDecoration(
        labelText: nome,
        contentPadding: EdgeInsets.only(left: 15, bottom: 8, top: 8),
      );
}
