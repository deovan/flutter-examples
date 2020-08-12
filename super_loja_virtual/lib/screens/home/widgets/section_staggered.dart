import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/home/home_manager.dart';
import 'package:super_loja_virtual/models/home/section.dart';
import 'package:super_loja_virtual/screens/home/widgets/add_tile_widget.dart';

import 'section_header.dart';
import 'section_item_tile.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;

  const SectionStaggered({Key key, this.section}) : super(key: key);

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
            Consumer<Section>(builder: (context, section, __) {
              return StaggeredGridView.countBuilder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: homeManager.editing
                    ? section.items.length + 1
                    : section.items.length,
                itemBuilder: (_, index) {
                  if (index < section.items.length)
                    return SectionItemTile(section.items[index]);
                  else
                    return AddTileWidget();
                },
                staggeredTileBuilder: (index) =>
                    StaggeredTile.count(2, index.isEven ? 2 : 1),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              );
            })
          ],
        ),
      ),
    );
  }
}
