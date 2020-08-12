import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/page_manager.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int page;

  const DrawerTile({Key key, this.icon, this.title, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;

    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 32,
              color: curPage == page ? primaryColor : Colors.grey[700],
            ),
            const SizedBox(
              width: 32,
            ),
            Text(
              title,
              style: TextStyle(
                color: curPage == page ? primaryColor : Colors.grey[700],
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
