import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase {
  final _titleController = BehaviorSubject<String>();
  final _iconController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
        if (title.isEmpty) {
          sink.addError("Insira um título");
        } else {
          sink.add(title);
        }
      }));

  Stream<bool> get outDelete => _deleteController.stream;

  Stream<bool> get submitValid =>
      Observable.combineLatest2(outIcon, outTitle, (a, b) => true);

  Stream get outIcon => _iconController.stream;

  Stream<bool> get outLoading => _loadingController.stream;

  File image;
  String title;

  DocumentSnapshot category;

  CategoryBloc(this.category) {
    if (category != null) {
      title = category.data['title'];
      _titleController.add(category.data["title"]);
      _iconController.add(category.data["icon"]);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  @override
  void dispose() {
    _titleController.close();
    _iconController.close();
    _deleteController.close();
    _loadingController.close();
  }

  void setIcon(File image) {
    this.image = image;
    _iconController.add(image);
  }

  void setTitle(String value) {
    title = value;
    _titleController.add(value);
  }

  Future<bool> saveData() async {
    _loadingController.add(true);
    if (image == null && category != null && title == category.data['title']) {
      _loadingController.add(false);
      return true;
    }
    try {
      Map<String, dynamic> dataToUpdate = {};
      if (image != null) {
        StorageUploadTask task = FirebaseStorage.instance
            .ref()
            .child('icons')
            .child(title)
            .putFile(image);

        StorageTaskSnapshot snap = await task.onComplete;
        dataToUpdate['icon'] = await snap.ref.getDownloadURL();
      }

      if (category == null || title != category?.data['title']) {
        dataToUpdate['title'] = title;
      }

      if (category == null) {
        await Firestore.instance
            .collection('products')
            .document(title.toLowerCase())
            .setData(dataToUpdate);
      } else {
        await category.reference.updateData(dataToUpdate);
      }
    } catch (e) {
      _loadingController.add(false);
      return false;
    }

    _loadingController.add(false);
    return true;
  }

  Future delete() async {
    await category.reference.delete();
  }
}
