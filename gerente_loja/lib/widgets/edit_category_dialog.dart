import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';

import 'image_source_sheet.dart';

class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  const EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() =>
      _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;
  final TextEditingController _controller;

  _EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _controller = TextEditingController(
            text: category != null ? category.data["title"] : "");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Dialog(
          child: Card(
              margin: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => ImageSourceSheet(
                                  onImageSelected: (image) {
                                    Navigator.of(context).pop();
                                    _categoryBloc.setIcon(image);
                                  },
                                ));
                      },
                      child: StreamBuilder(
                          stream: _categoryBloc.outIcon,
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return CircleAvatar(
                                child: snapshot.data is File
                                    ? Image.file(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                      ),
                                backgroundColor: Colors.transparent,
                              );
                            }
                            return CircleAvatar(
                              child: Icon(Icons.image),
                              backgroundColor: Colors.transparent,
                            );
                          }),
                    ),
                    title: StreamBuilder<String>(
                        stream: _categoryBloc.outTitle,
                        builder: (context, snapshot) {
                          return TextField(
                            controller: _controller,
                            onChanged: _categoryBloc.setTitle,
                            decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                            ),
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      StreamBuilder<bool>(
                          stream: _categoryBloc.outDelete,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == false)
                              return Container();
                            return FlatButton(
                              child: Text("Excluir"),
                              textColor: Colors.red,
                              onPressed: snapshot.data
                                  ? () async {
                                      await _categoryBloc.delete();
                                      Navigator.of(context).pop();
                                    }
                                  : null,
                            );
                          }),
                      StreamBuilder<bool>(
                          stream: _categoryBloc.submitValid,
                          builder: (context, snapshot) {
                            return FlatButton(
                              child: Text("Salvar"),
                              textColor: Colors.green,
                              onPressed: snapshot.hasData
                                  ? () async {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Salvando categoria...",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          duration: Duration(minutes: 1),
                                          backgroundColor: Colors.pinkAccent,
                                        ),
                                      );

                                      bool success =
                                          await _categoryBloc.saveData();
                                      Scaffold.of(context)
                                          .removeCurrentSnackBar();

                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.pinkAccent,
                                          content: Text(
                                            success
                                                ? "Categoria salva!"
                                                : "Falha ao salvar!",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          duration: Duration(seconds: 5),
                                        ),
                                      );
                                      if (success) Navigator.of(context).pop();
                                    }
                                  : null,
                            );
                          }),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
