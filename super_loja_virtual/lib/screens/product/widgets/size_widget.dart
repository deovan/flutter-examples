import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/product/item_size.dart';
import 'package:super_loja_virtual/models/product/product.dart';

class SizeWidget extends StatelessWidget {
  final ItemSize itemSize;

  const SizeWidget(this.itemSize);

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Product>();

    final selected = itemSize == product.selectSize;

    Color color = Colors.grey;
    if (!itemSize.hasStock) {
      color = Colors.red.withAlpha(50);
    }
    if (selected) {
      color = Theme.of(context).primaryColor;
    }

    return GestureDetector(
      onTap: () {
        if (itemSize.hasStock) product.selectSize = itemSize;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                itemSize.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "R\$ ${itemSize.price.toStringAsFixed(2)}",
                style: TextStyle(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
