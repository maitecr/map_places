import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_places/screens/map_screen.dart';
import 'package:map_places/utils/location_util.dart';

class LocationInput extends StatefulWidget{

  final Function onSelectPosition;
  
  const LocationInput(this.onSelectPosition, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
                                            latitude: lat, 
                                            longitude: lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });  
  }

  Future<void> _getCurrentUserLocation() async {

    try {
    final locData = await Location().getLocation();
    // print(locData.latitude);
    // print(locData.longitude);

    _showPreview(locData.latitude!, locData.longitude!);
    widget.onSelectPosition(LatLng(locData.latitude!, locData.longitude!));
    } catch(e) {
      return;
    }

  }

  Future<void> _selectOnMap() async {
    final LatLng selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(),
      ),
    );

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);

    //print(selectedPosition.latitude);

    widget.onSelectPosition(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
            width: 1, 
            color: Colors.grey,
            ),
          ),
          
          child: _previewImageUrl == null 
                ? Text('Localização não informada')
                : Image.network(_previewImageUrl!,
                fit: BoxFit.cover,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.location_on), 
              label: Text(
                'Localizaçao atual',
                style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map), 
              label: Text(
                'Selecione no mapa',
                style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}