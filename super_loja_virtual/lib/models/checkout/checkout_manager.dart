import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/cart/cart_manager.dart';
import 'package:super_loja_virtual/models/checkout/credit_card.dart';
import 'package:super_loja_virtual/models/checkout/order.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/services/cielo_payment.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;
  final Firestore firestore = Firestore.instance;
  final CieloPayment cieloPayment = CieloPayment();

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercount');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);

        final orderId = doc.data['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      return Future.error("Falha ao gerar o número do pedido");
    }
  }

  Future<void> checkout(
      {CreditCard creditCard,
      Function onStockFail,
      Function onSuccess,
      Function onPayFail}) async {
    loading = true;
    final orderId = await _getOrderId();
    String payId;
    try {
      payId = await cieloPayment.authorize(
        creditCard: creditCard,
        price: cartManager.totalPrice,
        orderId: orderId.toString(),
        user: cartManager.user,
      );
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch (e) {
      cieloPayment.cancel(payId);
      loading = false;
      onStockFail(e);
      return;
    }

    try {
      await cieloPayment.capture(payId);
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    final Order order = Order.fromCartManager(cartManager);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();
    cartManager.clear();
    loading = false;
    onSuccess(order);
  }

  Future<void> _decrementStock() {
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM

    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      if (cartManager.items.isEmpty) {
        return Future.error('Carrinho vazio');
      }

      for (final cartProduct in cartManager.items) {
        Product product;

        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(
            firestore.document('products/${cartProduct.productId}'),
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        final size = product.findSize(cartProduct.size);

        if (size.stock - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          size.stock -= cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produto(s) sem estoque');
      }

      for (final product in productsToUpdate) {
        tx.update(firestore.document('products/${product.id}'), {
          'sizes': product.exportSizesList(),
        });
      }
    });
  }
}
