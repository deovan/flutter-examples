import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:super_loja_virtual/models/stores/stores_manager.dart';
import 'package:super_loja_virtual/screens/stores/widgets/store_card.dart';

class StoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lojas"),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Consumer<StoresManager>(
        builder: (context, storesManager, child) {

          if(storesManager.stores.isEmpty){
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(
            itemCount: storesManager.stores.length,
            itemBuilder: (context, index) {
              return StoreCard(storesManager.stores[index]);
            },);
        },
      ),
    );
  }
}
