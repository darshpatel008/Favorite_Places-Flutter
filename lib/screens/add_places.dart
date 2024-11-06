
import 'dart:io';
import 'package:favorite_place/model/place.dart';
import 'package:favorite_place/providers/user_places.dart';
import 'package:favorite_place/widget/image_input.dart';
import 'package:favorite_place/widget/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AddPlacesScreen extends ConsumerStatefulWidget {
  const AddPlacesScreen({super.key});



  @override
  ConsumerState<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends ConsumerState<AddPlacesScreen> {

  File? selectedImage;
  PlaceLocation? selectedLocation;

  final _titleController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
  }


  void _savepage()
  {
    final enteredText = _titleController.text;

    if(enteredText.isEmpty || selectedImage == null || selectedLocation == null)
      {
        return;
      }

    ref.read(UserPlacesProvider.notifier).addPlace(enteredText , selectedImage!,selectedLocation!); //type of iamge in provider must be file
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Add New Places'),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface,),
                decoration: const InputDecoration(
                labelText: 'title'),
                controller: _titleController
              ),
            ),
            const SizedBox(height: 8),
            ImageInput( onPickImage: (image) //we executed in widget.onPickedImage and we got that image here no need of navigation just call class
              {
                 selectedImage = image;
              }
            ),
            const SizedBox(height: 8),
            LocationInput(
              onSelectLocation: (location)
              {
                selectedLocation = location;
              }
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
                onPressed: _savepage,
                icon: Icon(Icons.add),
                label:  Text('Add place')
            )
          ],
        ),
      ),
    );
  }
}
