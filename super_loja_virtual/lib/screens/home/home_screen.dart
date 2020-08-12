import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:super_loja_virtual/models/home/home_manager.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';
import 'package:super_loja_virtual/screens/home/widgets/add_section_widget.dart';
import 'package:super_loja_virtual/screens/home/widgets/section_list.dart';
import 'package:super_loja_virtual/screens/home/widgets/section_staggered.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                snap: true,
                floating: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("Loja do Deovan"),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, "/cart");
                    },
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (context, userManager, homeManager, child) {
                      if (userManager.adminEnabled && !homeManager.loading) {
                        if (homeManager.editing) {
                          return PopupMenuButton(
                            itemBuilder: (_) {
                              return ['Salvar', 'Descartar']
                                  .map((e) => PopupMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList();
                            },
                            onSelected: (value) {
                              if (value == "Salvar") {
                                homeManager.saveEditing();
                              } else {
                                homeManager.discardEditing();
                              }
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: homeManager.enterEditing,
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
              Consumer<HomeManager>(builder: (context, homeManager, child) {
                if (homeManager.loading)
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                final List<Widget> children =
                    homeManager.sections.map<Widget>((section) {
                  switch (section.type.toUpperCase()) {
                    case "LIST":
                      return SectionList(
                        section: section,
                      );
                    case "STAGGERED":
                      return SectionStaggered(
                        section: section,
                      );
                    default:
                      return Container();
                  }
                }).toList();
                if (homeManager.editing)
                  children.add(AddSectionWidget(
                    homeManager: homeManager,
                  ));
                return SliverList(
                  delegate: SliverChildListDelegate(children),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
