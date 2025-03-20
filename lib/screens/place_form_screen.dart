import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_places/providers/great_places.dart';
import 'package:map_places/widgets/image_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  const PlaceFormScreen({super.key});


  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {

  final _titleController = TextEditingController();
  File? _pickedImage;

  void _selectImage(File pickImage) {
    _pickedImage = pickImage;
  }

  void _submitForm() {
    if(_titleController.text.isEmpty || _pickedImage == null) {
      return;
    } 

    Provider.of<GreatPlaces>(context, listen: false).addPlace(_titleController.text, _pickedImage!);    

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

                    ImageInput(this._selectImage),
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
            onPressed: _submitForm, 
          )
        ],
      )
    );
  }
}