import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/home/home_manager.dart';
import 'package:super_loja_virtual/models/home/section.dart';
import 'package:super_loja_virtual/models/home/section_item.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/models/product/product_manager.dart';
import 'package:transparent_image/transparent_image.dart';

class SectionItemTile extends StatelessWidget {
  final SectionItem sectionItem;

  const SectionItemTile(this.sectionItem);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final product = context
                        .read<ProductManager>()
                        .findProductById(sectionItem.product);

                    return AlertDialog(
                      title: const Text("Editar Item"),
                      content: product != null
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images.first),
                              title: Text(product.name),
                              subtitle: Text(
                                  "R\$ ${product.basePrice.toStringAsFixed(2)}"),
                            )
                          : null,
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            context.read<Section>().removeItem(sectionItem);
                            Navigator.pop(context);
                          },
                          textColor: Colors.red,
                          child: const Text('Excluir'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (product != null) {
                              sectionItem.product = null;
                            } else {
                              final Product product = await Navigator.pushNamed(
                                  context, "/select_product") as Product;

                              sectionItem.product = product?.id;
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                              product != null ? 'Desvincular' : 'Vincular'),
                        )
                      ],
                    );
                  });
            }
          : null,
      onTap: sectionItem.product != null
          ? () {
              final product = context
                  .read<ProductManager>()
                  .findProductById(sectionItem.product);
              if(product != null){
                Navigator.pushNamed(context, "/product", arguments: product);
              }
            }
          : null,
      child: AspectRatio(
        aspectRatio: 1,
        child: sectionItem.image is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: sectionItem.image as String,
                fit: BoxFit.cover,
              )
            : Image.file(
                sectionItem.image as File,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
