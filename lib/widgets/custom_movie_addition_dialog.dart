import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';

// ignore: must_be_immutable
class CustomMovieAdditionDialog extends StatefulWidget {
  CustomMovieAdditionDialog({
    super.key,
    required this.imageUrl,
    required this.movieNameController,
    required this.personalRatingController,
    required this.imdbRatingController,
    required this.movieDescriptionController,
    required this.onAddMovie,
    required this.onCancel,
    required this.onImageUrlChanged,
  });

  String imageUrl;
  final TextEditingController movieNameController;
  final TextEditingController personalRatingController;
  final TextEditingController imdbRatingController;
  final TextEditingController movieDescriptionController;

  final VoidCallback onAddMovie;
  final VoidCallback onCancel;
  final Function(String) onImageUrlChanged;

  @override
  State<CustomMovieAdditionDialog> createState() =>
      _CustomMovieAdditionDialogState();
}

class _CustomMovieAdditionDialogState extends State<CustomMovieAdditionDialog> {
  String? _imageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  bool isLoading = false;
  final storageRef = FirebaseStorage.instance.ref();

  Future getImageFromGallery() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      uploadImageToFirebaseStorage(File(pickedImage.path));
      _imageUrl = pickedImage.path;
    }
  }

  Future uploadImageToFirebaseStorage(pickedImage) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      isLoading = true;
    });
    try {
      Reference movieRef = storageRef.child('movie_uploads/$fileName');
      await movieRef.putFile(pickedImage).whenComplete(() async {
        String downloadURL = await movieRef.getDownloadURL();
        Fluttertoast.showToast(msg: 'photo uploaded successfully');
        widget.onImageUrlChanged(downloadURL);
      });
    } catch (e) {
      print('error occurred : $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.appBgColor,
      content: SizedBox(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              autofocus: true,
              controller: widget.movieNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "MOVIE NAME",
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.personalRatingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "PERSONAL RATING",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: widget.imdbRatingController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "IMDB RATING",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: widget.movieDescriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "DESCRIPTION",
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _imageUrl == null
                    ? const Text('No image selected')
                    : CircleAvatar(
                        child: Image.file(
                          File(_imageUrl!),
                        ),
                      ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: getImageFromGallery,
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            if (isLoading)
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 20,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomMaterialButton(
                  text: "CANCEL",
                  onPressed: widget.onCancel,
                ),
                const SizedBox(width: 10),
                CustomMaterialButton(
                  text: "ADD MOVIE",
                  onPressed: widget.onAddMovie,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
