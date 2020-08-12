import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:super_loja_virtual/models/product/product_manager.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';
import 'package:super_loja_virtual/screens/products/widgets/search_dialog.dart';

import 'widgets/product_list_tile.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (context, productManager, child) {
            if (productManager.search.isEmpty) {
              return const Text("Produtos");
            }
            return LayoutBuilder(builder: (context, constraint) {
              return GestureDetector(
                onTap: () async {
                  final search = await showDialog<String>(
                    context: context,
                    builder: (_) => SearchDialog(
                      productManager.search,
                    ),
                  );

                  if (search != null) {
                    productManager.search = search;
                  }
                },
                child: Container(
                  width: constraint.biggest.width,
                  child: Text(
                    productManager.search,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            });
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit_product',
                    );
                  },
                );
              }
              return Container();
            },
          ),
          Consumer<ProductManager>(
            builder: (context, productManager, child) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                      context: context,
                      builder: (_) => SearchDialog(
                        productManager.search,
                      ),
                    );

                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                );
              }
              return IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  productManager.search = "";
                },
              );
            },
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Consumer<ProductManager>(
        builder: (_, productManager, child) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (_, index) {
                return ProductListTile(
                  product: filteredProducts[index],
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
