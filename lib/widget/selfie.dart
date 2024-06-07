import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageFile != null
            ? Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            : Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
              ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _pickImage(ImageSource.camera);
          },
          child: Text('Take Picture'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _pickImage(ImageSource.gallery);
          },
          child: Text('Choose from Gallery'),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_imageFile!);
      }
    } else {
      print('No image selected.');
    }
  }
}
