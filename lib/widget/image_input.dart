import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key,required this.onPickImage});

  final void Function(File img) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _PreviewImage;  //it can be null bcz user may not click photo for file use dart.io package

  void _takePicture() async {
    final imagepicker = ImagePicker(); //its a package

    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedimage == null) {
      return;
    }

    setState(() {
      _PreviewImage = File(pickedimage.path);  //pickedimage  type is xfile & previewimage type is file hence .path is needed
    });
    widget.onPickImage(_PreviewImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      label: Text('Take picture'),
      icon: Icon(Icons.camera),
      onPressed: _takePicture,
    );

    if (_PreviewImage != null)
    {
      content = GestureDetector(
         onTap: _takePicture,
          child: Image.file(
              _PreviewImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity));
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
