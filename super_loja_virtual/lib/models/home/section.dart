import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import 'section_item.dart';

class Section extends ChangeNotifier {
  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;

  String get error => _error;

  Firestore firestore = Firestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document("home/$id");

  StorageReference get storageRef => storage.ref().child('home').child(id);

  set error(String erro) {
    _error = erro;
    notifyListeners();
  }

  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    items = (document.data['items'] as List)
        .map(
          (item) => SectionItem.fromMap(item as Map<String, dynamic>),
        )
        .toList();
  }

  void addItem(SectionItem sectionItem) {
    items.add(sectionItem);
    notifyListeners();
  }

  void removeItem(SectionItem sectionItem) {
    items.remove(sectionItem);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = "Título inválido";
    } else if (items.isEmpty) {
      error = "Insira ao menos uma imagem";
    } else {
      error = null;
    }

    return error == null;
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);

        final StorageTaskSnapshot snapshot = await task.onComplete;

        await snapshot.ref.getDownloadURL().then(
              (value) => item.image = value,
            );
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) &&
          (original.image as String).contains('firebase')) {
        await storage
            .getReferenceFromUrl(original.image as String)
            .then((value) async => value.delete())
            .catchError((error) => debugPrint(error.toString()));
      }
    }

    final Map<String, dynamic> itemData = {
      'items': items.map((e) => e.toMap()).toList(),
    };

    await firestoreRef.updateData(itemData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      if ((item.image as String).contains('firebase')) {
        await storage
            .getReferenceFromUrl(item.image as String)
            .then((value) async => value.delete())
            .catchError((error) => debugPrint("Erro ao deletar $error"));
      }
    }
  }
}
