import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'product.dart';

class ProductManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  List<Product> allProducts = [];

  String _search = "";

  String get search => _search;

  set search(String search) {
    _search = search;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(
        allProducts.where(
          (element) => element.name.toLowerCase().contains(
                search.toLowerCase(),
              ),
        ),
      );
    }

    return filteredProducts;
  }

  ProductManager() {
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts = await firestore
        .collection("products")
        .where('deleted', isEqualTo: false)
        .getDocuments();

    allProducts = snapProducts.documents
        .map((element) => Product.fromDocument(element))
        .toList();

    notifyListeners();
  }

  Product findProductById(String productId) {
    try {
      return allProducts.firstWhere((p) => p.id == productId.trim());
    } catch (e) {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((element) => element.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }
}
