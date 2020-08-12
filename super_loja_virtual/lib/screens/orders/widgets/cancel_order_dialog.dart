import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';

class CancelOrderDialog extends StatefulWidget {
  final Order order;

  const CancelOrderDialog({Key key, this.order}) : super(key: key);

  @override
  _CancelOrderDialogState createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(loading
                ? "Cancelando..."
                : "Esta ação não poderá ser desfeita!\nDeseja continuar?"),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: !loading
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            textColor: Theme.of(context).primaryColor,
            child: const Text("Não"),
          ),
          FlatButton(
            onPressed: !loading
                ? () async {
                    setState(() {
                      error = '';
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }
                  }
                : null,
            textColor: Colors.red,
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }
}
