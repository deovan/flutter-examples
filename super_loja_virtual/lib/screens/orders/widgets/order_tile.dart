import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/screens/orders/widgets/cancel_order_dialog.dart';
import 'package:super_loja_virtual/screens/orders/widgets/export_address_dialog.dart';
import 'package:super_loja_virtual/screens/orders/widgets/order_product_tile.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final bool showControls;

  const OrderTile({Key key, this.order, this.showControls = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                color:
                    order.status == Status.canceled ? Colors.red : primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items
                .map<Widget>((e) => OrderProductTile(
                      cartProduct: e,
                    ))
                .toList(),
          ),
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CancelOrderDialog(
                                order: order,
                              ));
                    },
                    textColor: Colors.red,
                    child: const Text('Cancelar'),
                  ),
                  FlatButton(
                    onPressed: order.backStatus,
                    child: const Text('Recuar'),
                  ),
                  FlatButton(
                    onPressed: order.nextStatus,
                    child: const Text('Avançar'),
                  ),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ExportAddressDialog(
                          address: order.address,
                        ),
                      );
                    },
                    textColor: primaryColor,
                    child: const Text('Endereço'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
