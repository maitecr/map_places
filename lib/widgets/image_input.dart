import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {

  final Function onSelectImage;

  const ImageInput(this.onSelectImage, {super.key});
  
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {

  File? _storedImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;
 
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  } 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null ?
            Image.file(
              _storedImage!, 
              width: double.infinity,
              fit: BoxFit.cover,
            )
           : Text('Sem imagem'),
        ),

        SizedBox(width: 10,),
        Expanded(
          child: TextButton.icon(
            icon: Icon(
              Icons.camera,
              color: Colors.indigo,
              ), 
            label: Text(
              'Tirar foto',
              style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            onPressed: _takePicture,
          ),
        ),
          
      ],
    );
  }
}