import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_icon_button.dart';
import 'package:super_loja_virtual/models/home/home_manager.dart';
import 'package:super_loja_virtual/models/home/section.dart';

class SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    if (homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  initialValue: section.name,
                  decoration: InputDecoration(
                    hintText: 'Título',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                  onChanged: (value) => section.name = value,
                ),
              ),
              CustomIconButton(
                iconData: Icons.remove,
                color: Colors.white,
                onTap: () {
                  homeManager.removeSection(section);
                },
              )
            ],
          ),
          if (section.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                section.error,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        section.name ?? "",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
