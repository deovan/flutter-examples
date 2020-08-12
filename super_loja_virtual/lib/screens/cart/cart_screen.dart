import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/empty_card.dart';
import 'package:super_loja_virtual/common/login_card.dart';
import 'package:super_loja_virtual/common/price_card.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';

import 'widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, _) {
          if (cartManager.user == null) {
            return LoginCard();
          }
          if (cartManager.items.isEmpty) {
            return EmptyCard(
              title: "Nenhum produto no carrinho!",
              iconData: Icons.remove_shopping_cart,
            );
          }
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items.map((e) => CartTile(e)).toList(),
              ),
              PriceCard(
                buttonText: "Continuar para entrega",
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.pushNamed(context, '/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
