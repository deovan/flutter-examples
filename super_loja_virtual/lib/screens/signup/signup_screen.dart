import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/helpers/validators.dart';
import 'package:super_loja_virtual/models/user/user.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Criar Conta"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, child) => ListView(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Nome completo",
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enabled: !userManager.loading,
                    onSaved: (name) => user.name = name,
                    validator: (name) {
                      if (name.isEmpty) return "Campo obrigatório!";
                      if (name.trim().split(" ").length < 2)
                        return "Preencha seu nome completo";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enabled: !userManager.loading,
                    onSaved: (email) => user.email = email,
                    validator: (email) {
                      if (email.isEmpty) return "Campo obrigatório!";
                      if (!emailValid(email)) return "E-mail inválido";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Senha",
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    obscureText: true,
                    enabled: !userManager.loading,
                    onSaved: (pass) => user.pass = pass,
                    validator: (pass) {
                      if (pass.isEmpty) return "Campo obrigatório!";
                      if (pass.length < 6) return "Senha muito curta";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Repita a senha",
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    autocorrect: false,
                    obscureText: true,
                    enabled: !userManager.loading,
                    onSaved: (pass) => user.confirmPass = pass,
                    validator: (pass) {
                      if (pass.isEmpty) return "Campo obrigatório!";
                      if (pass.length < 6) return "Senha muito curta";
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();

                                if (user.pass != user.confirmPass) {
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          "Senha e confirmação de senha diferentes!"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                userManager.signUp(
                                    user: user,
                                    onSuccess: () {
                                      Navigator.pop(context);
                                    },
                                    onFail: (error) {
                                      scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    });
                              }
                            },
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              "Criar Conta",
                              style: TextStyle(fontSize: 15),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
