import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:super_loja_virtual/models/product/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.name,
      this.description,
      this.sizes,
      this.images,
      this.deleted = false}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.documentID;
    name = documentSnapshot['name'] as String;
    description = documentSnapshot['description'] as String;
    images =
        List<String>.from(documentSnapshot['images'] as List<dynamic> ?? []);
    sizes = (documentSnapshot.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
    deleted = (documentSnapshot.data['deleted'] ?? false) as bool;
  }

  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;
  bool deleted;
  Timestamp dateDeleted;

  ItemSize _selectSize;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Firestore firestore = Firestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document("products/$id");

  StorageReference get storageRef => storage.ref().child("products").child(id);

  List<dynamic> newImages;

  ItemSize get selectSize => _selectSize;

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) if (size.price < lowest) lowest = size.price;
    return lowest;
  }

  set selectSize(ItemSize item) {
    _selectSize = item;
    notifyListeners();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "sizes": exportSizesList(),
      "deleted": deleted,
    };

    if (id == null) {
      final doc = await firestore.collection("products").add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    final List<String> updateImages = [];
    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage.toString());
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);

        final StorageTaskSnapshot snapshot = await task.onComplete;

        await snapshot.ref
            .getDownloadURL()
            .then((value) => updateImages.add(value as String));
      }
    }
    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint("Falha ao deletar $image");
        }
      }
    }

    await firestoreRef.updateData({"images": updateImages});
    images = updateImages;
    loading = false;
  }

  List<Map<String, dynamic>> exportSizesList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }

    return stock;
  }

  bool get hasStock => totalStock > 0 && !deleted;

  ItemSize findSize(String size) {
    try {
      return sizes.firstWhere((s) => s.name == size);
    } catch (e) {
      return null;
    }
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((e) => e.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes, _selectSize: $_selectSize, newImages: $newImages}';
  }

  void delete() {
    firestoreRef.updateData({
      'deleted': true,
      'dateDeleted': Timestamp.now(),
    });
  }
}
