import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/cart/cart_product.dart';

class OrderProductTile extends StatelessWidget {
  final CartProduct cartProduct;

  const OrderProductTile({Key key, this.cartProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/product',
              arguments: cartProduct.product);
        },
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: Image.network(cartProduct.product.images.first),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              cartProduct.product.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            Text(
              'Tamanho: ${cartProduct.size}',
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'R\$: ${(cartProduct.fixedPrice ?? cartProduct.unitPrice).toStringAsFixed(2)}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Text(
          '${cartProduct.quantity}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
