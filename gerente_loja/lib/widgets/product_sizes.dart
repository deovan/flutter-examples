import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_size_dialog.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    bool autovalidate = false,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidate: autovalidate,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 34,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 4),
                      scrollDirection: Axis.horizontal,
                      children: state.value
                          .map((e) => GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      border: Border.all(
                                        color: Colors.pinkAccent,
                                        width: 3,
                                      )),
                                  alignment: Alignment.center,
                                  child: Text(
                                    e,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onLongPress: () {
                                  state.didChange(state.value..remove(e));
                                },
                              ))
                          .toList()
                            ..add(GestureDetector(
                              onTap: () async {
                                String sizeP = await showDialog(
                                    context: context,
                                    builder: (context) => AddSizeDialog());

                                if (sizeP is String && sizeP.length > 0) {
                                  state.didChange(state.value..add(sizeP));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                      color: state.hasError
                                          ? Colors.red
                                          : Colors.pinkAccent,
                                      width: 3,
                                    )),
                                alignment: Alignment.center,
                                child: Text(
                                  "+",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        )
                      : Container(),
                ],
              );
            });
}
