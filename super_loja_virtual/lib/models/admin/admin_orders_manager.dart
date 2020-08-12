import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/models/user/user.dart';

class AdminOrdersManager extends ChangeNotifier {
  bool adminEnabled = false;

  final List<Order> _orders = [];

  List<Status> statusFilter = [Status.preparing];

  List<Order> get filteredOrders {
    List<Order> output = _orders.reversed.toList();

    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter.id).toList();
    }

    if (statusFilter.isNotEmpty) {
      output = output.where((p) => statusFilter.contains(p.status)).toList();
    }

    return output;
  }

  User userFilter;

  Firestore firestore = Firestore.instance;

  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}) {
    this.adminEnabled = adminEnabled;
    _orders.clear();
    _subscription?.cancel();
    if (this.adminEnabled) {
      _listenToOrders();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((event) {
      for (final changes in event.documentChanges) {
        switch (changes.type) {
          case DocumentChangeType.added:
            _orders.add(Order.fromDocument(changes.document));
            break;
          case DocumentChangeType.modified:
            final modOrder = _orders.firstWhere(
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

  void setUserFilter(User user) {
    userFilter = user;
    notifyListeners();
  }

  void setStatusFilter({Status status, bool enabled}) {
    if (enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }
}
