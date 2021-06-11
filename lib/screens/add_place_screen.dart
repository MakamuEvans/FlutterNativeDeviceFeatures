import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loc/models/place.dart';
import 'package:flutter_loc/providers/great_places.dart';
import 'package:flutter_loc/widgets/image_input.dart';
import 'package:flutter_loc/widgets/location_widget.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _image;
  PlaceLocation _placeLocation;

  void _selectImage(File image){
    _image = image;
  }

  void _selectPlace(double lat, double lng){
    _placeLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savedPlace(){
    if (_titleController.text.isEmpty || _image == null || _placeLocation == null)
      return;
    Provider.of<GreatPlaces>(context, listen: false).addPlace(_titleController.text, _image, _placeLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10),
                    ImageInput(_selectImage),
                    SizedBox(height: 10,),
                    LocationWidget(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _savedPlace,
            icon: Icon(Icons.add),
            label: Text('Add Place'),
          )
        ],
      ),
    );
  }
}
