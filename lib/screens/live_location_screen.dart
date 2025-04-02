import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_places/models/place.dart';

class LiveLocationScreen extends StatefulWidget {
  final PlaceLocation savedPosition;

  LiveLocationScreen({
    super.key,
    required this.savedPosition, //DB saved location - lat/lng
  });

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScrrenState();
}

class _LiveLocationScrrenState extends State<LiveLocationScreen> {

  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(0, 0);
  Stream<Position>? _positionStream; //Geolocator library
  Marker? _markerCurrentLocation; //Current location marker
  Marker? _markerSavedLocation; //Saved location marker

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTrackingLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markerCurrentLocation = Marker(
        markerId: MarkerId("current_location"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      _markerSavedLocation = Marker(
        markerId: MarkerId("saved_location"),
        position: LatLng(widget.savedPosition.latitude, widget.savedPosition.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }


  void _startTrackingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30), // Atualiza a cada 30 segundos
      ),
    );

    _positionStream!.listen((Position position) { //Tracking live location
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markerCurrentLocation = Marker(
          markerId: MarkerId("current_location"),
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localização em tempo real..."),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15,
        ),
        markers: {
              if (_markerCurrentLocation != null) _markerCurrentLocation!, //User current location
              if (_markerSavedLocation != null) _markerSavedLocation!, //User original location
            },
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },  
      ),
    );
  }
}