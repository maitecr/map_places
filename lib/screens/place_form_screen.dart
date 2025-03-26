import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_places/providers/great_places.dart';
import 'package:map_places/widgets/image_input.dart';
import 'package:map_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});


  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {

  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _pickedPosition;

  void _selectImage(File pickImage) {
    setState(() {
      _pickedImage = pickImage;
    });
  }

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;      
    });

  }

  bool _isValidForm() {
    return _titleController.text.isNotEmpty && _pickedImage != null && _pickedPosition != null;
  }

  void _submitForm() {
    if(!_isValidForm()) return;

    Provider.of<GreatPlaces>(context, listen: false).addPlace(_titleController.text, _pickedImage!, _pickedPosition!);    

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicione Lugar'),
      ),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded( //Expandir o formulário para a coluna do botão permanecer ao final da tela
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título', 
                      ),
                    ),
                    
                    SizedBox(height: 10,),

                    ImageInput(_selectImage),

                    SizedBox(height: 10,),

                    LocationInput(_selectPosition),
                  ],
                ),
              ),
            ),
          ),
          
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.amber),
              elevation: WidgetStateProperty.all<double>(0),
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero, // Remove as bordas arredondadas
                                                ) 
                                              ),
            ),
            onPressed: _isValidForm() ? _submitForm : null, 
          )
        ],
      )
    );
  }
}