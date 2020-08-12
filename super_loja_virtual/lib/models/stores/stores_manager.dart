import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_loja_virtual/models/stores/store.dart';

class StoresManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;

  List<Store> stores = [];
  Timer _timer;

  StoresManager() {
    _loadStoreList();
  }

  Future<void> _loadStoreList() async {
    final snapshot = await firestore.collection('stores').getDocuments();

    stores = snapshot.documents.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
