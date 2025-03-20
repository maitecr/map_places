// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:map_places/providers/great_places.dart';
import 'package:map_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget{
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus lugares'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PLACE_FORM);
            },
          )
        ],
      ),

      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
        ? Center(child: CircularProgressIndicator(),)
        : Consumer<GreatPlaces>(
          child:  Center(
            child: Text('Nenhum local cadastrado'),
          ),
          builder: (ctx, greatPlaces, ch) => greatPlaces.itemsCount == 0 
                                            ? (ch ?? SizedBox.shrink())  
                                            : ListView.builder(
                                                itemCount: greatPlaces.itemsCount,
                                                itemBuilder: (ctx, i) => ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundImage: FileImage(
                                                      greatPlaces.itemByIndex(i).image,
                                                    ),
                                                  ),
                                                  title: Text(greatPlaces.itemByIndex(i).title),
                                                  onTap: () {},
                                                ),
                                              ),
        ),
      ),
    );
  }
}