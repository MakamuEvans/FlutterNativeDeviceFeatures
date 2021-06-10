import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loc/providers/great_places.dart';
import 'package:flutter_loc/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                })
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<GreatPlaces>(
                  child: Center(
                    child: Text('Got no places yet! Start adding!'),
                  ),
                  builder: (ctx, greatPlaces, ch) =>
                      greatPlaces.places.length <= 0
                          ? ch
                          : ListView.builder(
                              itemBuilder: (ctx, i) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      FileImage(greatPlaces.places[i].image),
                                ),
                                title: Text(greatPlaces.places[i].title),
                                onTap: () {},
                              ),
                              itemCount: greatPlaces.places.length,
                            ),
                ),
        ));
  }
}
