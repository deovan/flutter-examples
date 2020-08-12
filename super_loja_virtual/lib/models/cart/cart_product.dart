import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/product/item_size.dart';
import 'package:super_loja_virtual/models/product/product.dart';

class CartProduct extends ChangeNotifier {
  String id;
  String productId;
  int quantity;

  String size;
  Product _product;
  num fixedPrice;

  Product get product => _product;

  set product(Product value) {
    _product = value;
    notifyListeners();
  }

  Firestore firestore = Firestore.instance;

  CartProduct.fromProduct(this._product) {
    productId = product.id;
    quantity = 1;
    size = product.selectSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    firestore.document('products/$productId').get().then((value) {
      product = Product.fromDocument(value);
    });
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore.document('products/$productId').get().then((value) {
      product = Product.fromDocument(value);
    });
  }

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return null;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice != null ? unitPrice * quantity : 0.0;

  Map<String, dynamic> toCartItemMap() {
    return {'pid': productId, 'quantity': quantity, 'size': size};
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if (product != null && product.deleted) return false;
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice
    };
  }
}
