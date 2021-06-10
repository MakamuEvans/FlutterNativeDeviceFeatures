import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loc/helpers/db_helper.dart';
import 'package:flutter_loc/models/plade.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DbHelper.getData("great_places");
    _places = dataList
        .map((e) => Place(
            id: e['id'],
            title: e['title'],
            PlaceLocationlocation: null,
            image: File(e['image'])))
        .toList();
    notifyListeners();
  }

  addPlace(String title, File image) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        PlaceLocationlocation: null,
        image: image);
    _places.add(newPlace);
    notifyListeners();
    DbHelper.insert("great_places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });
  }
}
