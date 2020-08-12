import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:super_loja_virtual/models/address/address.dart';
import 'package:super_loja_virtual/models/product/product.dart';
import 'package:super_loja_virtual/models/user/user.dart';
import 'package:super_loja_virtual/models/user/user_manager.dart';
import 'package:super_loja_virtual/services/cepaberto_service.dart';

import 'cart_product.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  User user;

  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  num get totalPrice => productsPrice + (deliveryPrice ?? 0.0);

  final Firestore firestore = Firestore.instance;

  Future<void> _loadingCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
    items = cartSnap.documents
        .map((e) => CartProduct.fromDocument(e)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap()).then((value) {
        cartProduct.id = value.documentID;
        _onItemUpdated();
      });
    }
    notifyListeners();
  }

  Future<void> updateUser(UserManager userManager) async {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      await _loadingCartItems();
      await _loadingUserAddress();
    }
  }

  void _removeFromCart(CartProduct cartProduct) {
    items.removeWhere((element) => element.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        _removeFromCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct?.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    user.cartReference
        .document(cartProduct.id)
        .updateData(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    if (items.isEmpty) return false;
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  Future<void> getAddress(String cep) async {
    loading = true;
    final CepAbertoService cepAbertoService = CepAbertoService();

    try {
      final cepAddress = await cepAbertoService.getAddressFromCep(cep);

      if (cepAddress != null) {
        address = Address(
          street: cepAddress.logradouro,
          district: cepAddress.bairro,
          zipCode: cepAddress.cep,
          city: cepAddress.cidade.nome,
          state: cepAddress.estado.sigla,
          lat: cepAddress.latitude,
          long: cepAddress.longitude,
        );
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if (await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    final maxkm = doc.data['maxkm'] as num;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;

    double distancia =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);

    distancia /= 1000;

    if (distancia > maxkm) {
      return false;
    }

    deliveryPrice = base + distancia * km;
    return true;
  }

  Future<void> _loadingUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
  }

  Future<void> clear() {
    for (final cartProduct in items) {
      user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }
}
