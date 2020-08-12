import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/models/user/user.dart';

class OrdersManager extends ChangeNotifier {
  User user;

  List<Order> orders = [];

  Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  // ignore: use_setters_to_change_properties
  void updateUser(User user) {
    this.user = user;
    orders.clear();
    _subscription?.cancel();
    if (user != null) {
      _listenToOrders();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('user', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      for (final changes in event.documentChanges) {
        switch (changes.type) {
          case DocumentChangeType.added:
            orders.add(Order.fromDocument(changes.document));
            break;
          case DocumentChangeType.modified:
            final modOrder = orders.firstWhere(
                (element) => element.orderId == changes.document.documentID);

            modOrder.updateFromDocument(changes.document);
            break;
          case DocumentChangeType.removed:
          default:
            break;
        }
      }
      notifyListeners();
    });
  }
}
