import 'package:flutter/material.dart';
import 'package:map_places/providers/great_places.dart';
import 'package:map_places/screens/live_location_screen.dart';
import 'package:map_places/screens/place_detail_screen.dart';
import 'package:map_places/screens/place_form_screen.dart';
import 'package:map_places/screens/places_list_screen.dart';
import 'package:map_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          primaryColor: Colors.indigo,
          hintColor: Colors.amber,
        ),
        home: PlacesListScreen(),
//        home: LiveLocationScreen(),
        routes: {
          AppRoutes.PLACE_FORM: (ctx) => PlaceFormScreen(),
          AppRoutes.PLACE_DETAIL: (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
