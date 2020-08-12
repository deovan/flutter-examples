import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/screens/orders/widgets/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {
  final Order order;

  const ConfirmationScreen(this.order);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido realizado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pedido nº ${order.formattedId}',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Valor total: R\$ ${order.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: order.items
                    .map<Widget>((e) => OrderProductTile(
                          cartProduct: e,
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
