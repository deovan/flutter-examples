import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';

import '../user/user.dart';

class AdminUsersManager extends ChangeNotifier {
  List<User> users = [];
  Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _listenToUsers() {
    _subscription = firestore.collection('users').snapshots().listen((value) {
      users = value.documents.map((e) => User.fromDocument(e)).toList();
      users.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();
}
