import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';

// ignore: must_be_immutable
class CustomMovieAdditionDialog extends StatefulWidget {
  const CustomMovieAdditionDialog({
    super.key,
    required this.movieNameController,
    required this.personalRatingController,
    required this.imdbRatingController,
    required this.movieDescriptionController,
    required this.onAddMovie,
    required this.onCancel,
  });

  final TextEditingController movieNameController;
  final TextEditingController personalRatingController;
  final TextEditingController imdbRatingController;
  final TextEditingController movieDescriptionController;

  final VoidCallback onAddMovie;
  final VoidCallback onCancel;

  @override
  State<CustomMovieAdditionDialog> createState() =>
      _CustomMovieAdditionDialogState();
}

class _CustomMovieAdditionDialogState extends State<CustomMovieAdditionDialog> {
  XFile? _image;
  final ImagePicker _imagePicker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
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
                _image == null
                    ? const Text('No image selected')
                    : CircleAvatar(
                        child: Image.file(
                          File(_image!.path),
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
