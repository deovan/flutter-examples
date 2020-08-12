import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/address/address.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';
import 'package:super_loja_virtual/screens/address/widgets/address_input_field.dart';
import 'package:super_loja_virtual/screens/address/widgets/cep_input_field.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(builder: (context, cartManager, child) {
          final address = cartManager.address ?? Address();
          return Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Endereço de Entrega",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                CepInputField(address),
                AddressInputField(address: address),
              ],
            ),
          );
        }),
      ),
    );
  }
}
