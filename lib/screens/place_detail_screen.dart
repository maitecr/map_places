import 'package:flutter/material.dart';
import 'package:map_places/models/place.dart';
import 'package:map_places/screens/map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key});


@override
  Widget build(BuildContext context) {

    final Place place = ModalRoute.of(context)?.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            place.location?.address ?? 'Endereço não disponível',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10,),
          TextButton.icon(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    isReadOnly: true,
                    initialLocation: place.location!,
                  )
                ),
              );
            }, 
            label: Text('Ver no mapa')),
        ],
      ),
    );
  }

}