import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/home/home_manager.dart';
import 'package:super_loja_virtual/models/home/section.dart';
import 'package:super_loja_virtual/screens/home/widgets/add_tile_widget.dart';
import 'package:super_loja_virtual/screens/home/widgets/section_header.dart';
import 'package:super_loja_virtual/screens/home/widgets/section_item_tile.dart';

class SectionList extends StatelessWidget {
  final Section section;

  const SectionList({Key key, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
            SizedBox(
              height: 150,
              child: Consumer<Section>(builder: (context, section, child) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    if (index < section.items.length)
                      return SectionItemTile(section.items[index]);
                    else
                      return AddTileWidget();
                  },
                  separatorBuilder: (_, __) => const SizedBox(
                    width: 4,
                  ),
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
