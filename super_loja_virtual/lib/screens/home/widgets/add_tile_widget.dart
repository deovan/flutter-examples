import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/home/section.dart';
import 'package:super_loja_virtual/models/home/section_item.dart';
import 'package:super_loja_virtual/screens/edit_product/widgets/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();
    void onImageSelected(File file) {
      section.addItem(SectionItem(image: file));
      Navigator.pop(context);
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
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
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
