import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // To handle File paths

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image; // To hold the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize image picker

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Convert XFile to File
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage, // Button to pick an image from gallery
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            _image != null // Display selected image, if available
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  )
                : const Text('No image selected'),
            const SizedBox(height: 20),
            _image != null // Upload button appears only if image is selected
                ? ElevatedButton(
                    onPressed: () {
                      // Add your upload function here (e.g., upload to server)
                      print('Image ready for upload: ${_image!.path}');
                    },
                    child: const Text('Upload Image'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
