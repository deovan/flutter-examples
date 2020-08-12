import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:super_loja_virtual/models/address/address.dart';

class ExportAddressDialog extends StatelessWidget {
  final Address address;

  ExportAddressDialog({Key key, this.address}) : super(key: key);

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      title: const Text(
        'Endereço de Entrega',
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
              '${address.street}, ${address.number} ${address.complement}\n'
              '${address.district}\n'
              '${address.city} - ${address.state}\n'
              '${address.zipCode},'),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            final file = await screenshotController.capture();
            await GallerySaver.saveImage(file.path);

            Navigator.pop(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Exportar'),
        )
      ],
    );
  }
}
