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
  File? _storedImage; // this stores in memory

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    try {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if(imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
      });

      //  get app directory for app data on device
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      //  get file name where it is stored in temporarly dir
      final fileName = path.basename(imageFile!.path);
      // copy image into system path
      final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');

      // call callback function which was passed from parent i.e. add_place_screen.dart
      // this will get called after image is selected and stored
      widget.onSelectImage(savedImage);

    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // preview container
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage as File,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Taken.',
                  textAlign: TextAlign.center,
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
