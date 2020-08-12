import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final String initialValue;

  const SearchDialog(this.initialValue);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              initialValue: initialValue,
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(
                    color: Colors.grey[700],
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              onFieldSubmitted: (text) {
                Navigator.pop(context, text);
              },
            ),
          ),
        )
      ],
    );
  }
}
