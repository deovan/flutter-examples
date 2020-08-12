import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:super_loja_virtual/helpers/extensions.dart';
import 'package:super_loja_virtual/models/address/address.dart';

class User {
  String id;
  String email;
  String pass;
  String name;
  String cpf;
  String confirmPass;
  bool admin = false;
  Address address;

  DocumentReference get firestoreRef =>
      Firestore.instance.document("users/$id");

  CollectionReference get cartReference => firestoreRef.collection("cart");

  CollectionReference get tokensReference => firestoreRef.collection("tokens");

  User({this.id, this.email, this.pass, this.name, this.confirmPass});

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data["name"].toString().capitalize();
    email = document.data["email"].toString();
    cpf = document.data["cpf"].toString();
    if (document.data.containsKey('address')) {
      address =
          Address.fromMap(document.data["address"] as Map<String, dynamic>);
    }
  }

  Future<void> saveDate() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      if (address != null) "address": address.toMap(),
      if (cpf != null) "cpf": cpf,
    };
  }

  void setAddress(Address address) {
    this.address = address;

    saveDate();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveDate();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await tokensReference.document(token).setData({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
    print(token);
  }
}
