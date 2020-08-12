import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:super_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:super_loja_virtual/common/custom_icon_button.dart';
import 'package:super_loja_virtual/common/empty_card.dart';
import 'package:super_loja_virtual/models/admin/admin_orders_manager.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/screens/orders/widgets/order_tile.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos os Pedidos"),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<AdminOrdersManager>(
        builder: (context, ordersManager, child) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: _panelController,
            minHeight: 40,
            maxHeight: 250,
            borderRadius: BorderRadius.circular(10),
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (_panelController.isPanelClosed) {
                      _panelController.open();
                    } else {
                      _panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values
                        .map((s) => CheckboxListTile(
                              title: Text(
                                Order.getStatusText(s),
                              ),
                              dense: true,
                              activeColor: Theme.of(context).primaryColor,
                              value: ordersManager.statusFilter.contains(s),
                              onChanged: (v) {
                                ordersManager.setStatusFilter(
                                    status: s, enabled: v);
                              },
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Pedidos de  ${ordersManager.userFilter.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  Expanded(
                    child: EmptyCard(
                      title: "Nenhuma venda realizada!",
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return OrderTile(
                          showControls: true,
                          order: filteredOrders[index],
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 142,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
