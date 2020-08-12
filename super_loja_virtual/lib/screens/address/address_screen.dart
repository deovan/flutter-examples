import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/price_card.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';
import 'package:super_loja_virtual/screens/address/widgets/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrega"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(builder: (_, cartManaget, __) {
            return PriceCard(
              buttonText: "Continuar para o Pagamento",
              onPressed: cartManaget.isAddressValid
                  ? () {
                      Navigator.pushNamed(context, '/checkout');
                    }
                  : null,
            );
          })
        ],
      ),
    );
  }
}
