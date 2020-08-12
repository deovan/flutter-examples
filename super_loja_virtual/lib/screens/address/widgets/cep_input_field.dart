import 'package:brasil_fields/formatter/cep_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_icon_button.dart';
import 'package:super_loja_virtual/models/address/address.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';

class CepInputField extends StatefulWidget {
  final Address address;

  const CepInputField(this.address);

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: cepController,
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
              isDense: true,
              labelText: "CEP",
              hintText: '12.345-789',
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty) {
                return 'Campo obrigatório';
              } else if (cep.length != 10) {
                return 'CEP Inválido';
              }
              return null;
            },
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                       await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("$e"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                : null,
            color: primaryColor,
            textColor: Colors.white,
            disabledColor: primaryColor.withAlpha(100),
            child: const Text("Buscar CEP"),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 18,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}
