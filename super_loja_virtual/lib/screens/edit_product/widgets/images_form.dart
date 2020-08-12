import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/screens/edit_product/widgets/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  final Product product;

  const ImagesForm({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      onSaved: (images) => product.newImages = images,
      validator: (images) {
        if (images.isEmpty) {
          return "Insira ao menos uma imagem";
        }
        return null;
      },
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.pop(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                dotSpacing: 15,
                images: state.value.map<Widget>(
                  (image) {
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        //image
                        if (image is String)
                          Image.network(
                            image,
                            fit: BoxFit.cover,
                          )
                        else
                          Image.file(
                            image as File,
                            fit: BoxFit.cover,
                          ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.remove),
                            color: Colors.red,
                            onPressed: () {
                              state.value.remove(image);
                              state.didChange(state.value);
                            },
                          ),
                        )
                      ],
                    );
                  },
                ).toList()
                  ..add(Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      iconSize: 50,
                      color: primaryColor,
                      onPressed: () {
                        if (Platform.isAndroid)
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                    onImageSelected: onImageSelected,
                                  ));
                        else
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => ImageSourceSheet(
                              onImageSelected: onImageSelected,
                            ),
                          );
                      },
                    ),
                  )),
              ),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  state.errorText,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
