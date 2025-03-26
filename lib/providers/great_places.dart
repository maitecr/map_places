import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_places/models/place.dart';
import 'package:map_places/utils/db_util.dart';
import 'package:map_places/utils/location_util.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];
  
  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList.map(
      (item) => Place(
                id: item['id'], 
                title: item['title'], 
                image: File(item['image']), 
                location: PlaceLocation(latitude: item['lat'], longitude: item['lng'], address: item['address']),
              ),
    ).toList();
    notifyListeners();
  }

  List<Place> get items {
    return [..._items]; //Operador spread para retornar um clone da lista e não a referência direta dela
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  void addPlace(String title, File image, LatLng position) async {

    String address = await LocationUtil.getAddressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(), 
      title: title, 
      location: PlaceLocation(latitude: position.latitude, longitude: position.longitude, address: address),
      image: image,
      );

    _items.add(newPlace);
    DbUtil.insert(
      'places', 
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': position.latitude,
        'lng': position.longitude,
        'address': address,
      }
      );
    notifyListeners();
  }
}