import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:super_loja_virtual/common/empty_card.dart';
import 'package:super_loja_virtual/common/login_card.dart';
import 'package:super_loja_virtual/models/checkout/orders_manager.dart';
import 'package:super_loja_virtual/screens/orders/widgets/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<OrdersManager>(builder: (context, ordersManager, child) {
        if (ordersManager.user == null) {
          return LoginCard();
        }
        if (ordersManager.orders.isEmpty) {
          return EmptyCard(
            title: "Nenhum pedido encontrado!",
            iconData: Icons.border_clear,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: ordersManager.orders.length,
          itemBuilder: (context, index) {
            return OrderTile(
                order: ordersManager.orders.reversed.toList()[index]);
          },
        );
      }),
    );
  }
}
