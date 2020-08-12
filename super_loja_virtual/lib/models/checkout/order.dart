import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_loja_virtual/models/address/address.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';
import 'package:super_loja_virtual/models/cart/cart_product.dart';
import 'package:super_loja_virtual/services/cielo_payment.dart';

enum Status {
  canceled,
  preparing,
  transporting,
  delivered,
}

class Order {
  List<CartProduct> items;
  num price;
  String orderId;
  String payId;
  String userId;
  Address address;
  Timestamp date;
  Status status;

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  final Firestore firestore = Firestore.instance;

  String get formattedId => '#${orderId.padLeft(7, '0')}';

  DocumentReference get orderRef =>
      firestore.collection('orders').document(orderId);

  Future<void> save() {
    orderRef.setData({
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'payId': payId,
      'address': address.toMap(),
      'status': status.index,
      'date': Timestamp.now(),
    });
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.documentID;
    items = (doc.data['items'] as List<dynamic>)
        .map((e) => CartProduct.fromMap(e as Map<String, dynamic>))
        .toList();
    price = doc.data['price'] as num;
    userId = doc.data['user'] as String;
    payId = doc.data['payId'] as String;
    address = Address.fromMap(doc.data['address'] as Map<String, dynamic>);
    date = doc.data['date'] as Timestamp;
    status = Status.values[doc.data['status'] as int];
  }

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{items: $items, price: $price, orderId: $orderId, userId: $userId, address: $address, date: $date, firestore: $firestore}';
  }

  Function() get backStatus {
    return (status.index >= Status.transporting.index)
        ? () {
            status = Status.values[status.index - 1];
            _updateStatus(status);
          }
        : null;
  }

  Function() get nextStatus {
    return (status.index <= Status.transporting.index)
        ? () {
            status = Status.values[status.index + 1];
            _updateStatus(status);
          }
        : null;
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);

      status = Status.canceled;
      _updateStatus(status);
    } catch (e) {
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  void _updateStatus(Status status) {
    orderRef.updateData({
      'status': status.index,
    });
  }

  void updateFromDocument(DocumentSnapshot document) {
    status = Status.values[document.data['status'] as int];
  }
}
