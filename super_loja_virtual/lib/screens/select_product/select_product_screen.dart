import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/product/product_manager.dart';

class SelectProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Vincular Produto"),
        centerTitle: true,
      ),
      body: Consumer<ProductManager>(
        builder: (context, productManager, child) => ListView.builder(
            itemCount: productManager.allProducts.length,
            itemBuilder: (context, index) {
              final product = productManager.allProducts[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text("R\$ ${product.basePrice.toStringAsFixed(2)}"),
                onTap: () {
                  Navigator.pop(context, product);
                },
              );
            }),
      ),
    );
  }
}
