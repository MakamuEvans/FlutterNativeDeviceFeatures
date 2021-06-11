import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loc/helpers/db_helper.dart';
import 'package:flutter_loc/helpers/location_helper.dart';
import 'package:flutter_loc/models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Place findById(String id){
    return _places.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DbHelper.getData("great_places");
    _places = dataList
        .map((e) => Place(
            id: e['id'],
            title: e['title'],
            placeLocation: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address']),
            image: File(e['image'])))
        .toList();
    notifyListeners();
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation placeLocation) async {
    final address = await LocationHelper.getPlacesAddress(
        placeLocation.latitude, placeLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: placeLocation.latitude,
        longitude: placeLocation.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        placeLocation: updatedLocation,
        image: image);
    _places.add(newPlace);
    notifyListeners();
    DbHelper.insert("great_places", {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.placeLocation.longitude,
      'loc_lng': newPlace.placeLocation.longitude,
      'address': newPlace.placeLocation.address
    });
  }
}
