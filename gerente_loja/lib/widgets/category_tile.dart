import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/product_screen.dart';

import 'edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryTile({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => EditCategoryDialog(
                  category: category,
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(category.data['icon']),
              backgroundColor: Colors.transparent,
            ),
          ),
          title: Text(
            category.data["title"],
            style: TextStyle(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
            ),
          ),
          children: <Widget>[
            FutureBuilder<QuerySnapshot>(
              future: category.reference.collection("items").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return Column(
                    children: snapshot.data.documents
                        .map(
                          (e) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(e.data['images'][0]),
                            ),
                            title: Text(e.data["title"]),
                            trailing: Text(
                                "R\$${e.data['price'].toStringAsFixed(2)}"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        categoryId: category.documentID,
                                        product: e,
                                      )));
                            },
                          ),
                        )
                        .toList()
                          ..add(ListTile(
                            title: Text("Adicionar"),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                        categoryId: category.documentID,
                                      )));
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.add,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          )),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
