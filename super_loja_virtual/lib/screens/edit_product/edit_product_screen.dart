import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/models/product/product_manager.dart';
import 'package:super_loja_virtual/screens/edit_product/widgets/images_form.dart';
import 'package:super_loja_virtual/screens/edit_product/widgets/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Product product;
  final bool editing;

  EditProductScreen(Product p)
      : product = p?.clone() ?? Product(),
        editing = p != null;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? "Editar Produto" : "Criar Produto"),
          centerTitle: true,
          actions: <Widget>[
            if(editing)
              IconButton(
                icon:  Icon(Icons.delete),
                onPressed: (){
                  context.read<ProductManager>().delete(product);
                  Navigator.pop(context);
                },
              )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(
                product: product,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.name,
                      decoration: InputDecoration(
                        hintText: "Título",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name.length < 6) {
                          return "Título muito curto";
                        }
                        return null;
                      },
                      onSaved: (name) => product.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "A partir de",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      "R\$ ...",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        "Descrição",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      decoration: InputDecoration(
                        hintText: "Descrição",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) {
                          return "Descrição muito curta";
                        }
                        return null;
                      },
                      onSaved: (desc) => product.description = desc,
                    ),
                    SizesForm(product: product),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Product>(builder: (context, product, child) {
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          color: primaryColor,
                          textColor: Colors.white,
                          disabledColor: primaryColor.withAlpha(100),
                          onPressed: !product.loading
                              ? () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    await product.save();
                                    context
                                        .read<ProductManager>()
                                        .update(product);
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          child: product.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  "Salvar",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      );
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
