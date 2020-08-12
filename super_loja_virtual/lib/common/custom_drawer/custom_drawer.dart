import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';

import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withAlpha(800),
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(
                icon: Icons.home,
                title: "Inicio",
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                title: "Produtos",
                page: 1,
              ),
              DrawerTile(
                  icon: Icons.playlist_add_check,
                  title: "Meus Pedidos",
                  page: 2),
              DrawerTile(
                icon: Icons.location_on,
                title: "Lojas",
                page: 3,
              ),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return Column(
                      children: <Widget>[
                        const Divider(),
                        DrawerTile(
                          icon: Icons.settings,
                          title: "Usuários",
                          page: 4,
                        ),
                        DrawerTile(
                          icon: Icons.settings,
                          title: "Pedidos",
                          page: 5,
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
