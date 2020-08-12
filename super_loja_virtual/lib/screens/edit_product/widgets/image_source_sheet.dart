import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final ImagePicker picker = ImagePicker();

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String path) async {
      final File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: "Editar Imagem",
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        iosUiSettings: const IOSUiSettings(
            title: "Editar Imagem",
            cancelButtonTitle: "Cancelar",
            doneButtonTitle: "Concluir"),
      );

      if (croppedFile != null) onImageSelected(croppedFile);
    }

    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Selecione a origem da foto",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(),
            FlatButton(
              onPressed: () async {
                final file = await picker.getImage(source: ImageSource.camera);
                editImage(file.path);
              },
              child: const Text("Câmera"),
            ),
            FlatButton(
              onPressed: () async {
                final file = await picker.getImage(source: ImageSource.gallery);
                editImage(file.path);
              },
              child: const Text("Galeria"),
            )
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: const Text("Selecionar a foto para o item"),
        message: const Text("Escolha a origem da foto"),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.red),
          ),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              final file = await picker.getImage(source: ImageSource.camera);
              editImage(file.path);
            },
            child: const Text("Câmera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final file = await picker.getImage(source: ImageSource.gallery);
              editImage(file.path);
            },
            child: const Text("Galeria"),
          )
        ],
      );
  }
}
