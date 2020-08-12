import 'package:flutter/material.dart';
import 'package:xlo/models/ad.dart';

class DescriptionPanel extends StatefulWidget {
  final Ad ad;

  const DescriptionPanel({Key key, @required this.ad}) : super(key: key);

  @override
  _DescriptionPanelState createState() => _DescriptionPanelState();
}

class _DescriptionPanelState extends State<DescriptionPanel> {
  Ad get ad => widget.ad;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 14),
          child: Text(
            "Descrição",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 14),
          child: Text(
            ad.description,
            maxLines: open ? null : 2,
            overflow: open ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (open || ad.description.length < 100)
          const SizedBox(
            height: 18,
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: FlatButton(
              padding: EdgeInsets.zero,
              child: Text(
                "Ver mais",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.purple),
              ),
              onPressed: () {
                setState(() {
                  open = true;
                });
              },
            ),
          )
      ],
    );
  }
}
