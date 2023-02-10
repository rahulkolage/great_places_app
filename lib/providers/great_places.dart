import 'dart:io';
import 'package:flutter/material.dart';

import './../models/place.dart';
import './../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  // getter
  // copy of _items
  List<Place> get items {
    // spread operator, returns copy of _items
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: pickedTitle,
      location: null,
      image: pickedImage,
    );

    _items.add(newPlace);
    notifyListeners();

    // store in device database
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }
}
