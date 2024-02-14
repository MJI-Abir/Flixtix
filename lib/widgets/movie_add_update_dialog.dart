import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviflix/enums/enums.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';

// ignore: must_be_immutable
class MovieAddUpdateDialog extends StatefulWidget {
  MovieAddUpdateDialog({
    super.key,
    required this.buttonFunctionality,
    required this.movieNameController,
    required this.personalRatingController,
    required this.imdbRatingController,
    required this.movieDescriptionController,
    required this.onCancel,
    this.imageUrl,
    this.movieName,
    this.personalRating,
    this.imdbRating,
    this.movieDescription,
    this.onAddMovie,
    this.onUpdateMovie,
    this.onImageUrlChanged,
  });

  final ButtonFunctionality buttonFunctionality;
  final TextEditingController movieNameController;
  final TextEditingController personalRatingController;
  final TextEditingController imdbRatingController;
  final TextEditingController movieDescriptionController;
  final VoidCallback onCancel;

  String? imageUrl;
  final String? movieName;
  final double? personalRating;
  final double? imdbRating;
  final String? movieDescription;

  final VoidCallback? onAddMovie;
  final VoidCallback? onUpdateMovie;
  final Function(String)? onImageUrlChanged;

  @override
  State<MovieAddUpdateDialog> createState() => _MovieAddUpdateDialogState();
}

class _MovieAddUpdateDialogState extends State<MovieAddUpdateDialog> {
  String? _imageUrl;
  String? _updatedImageUrl;

  final ImagePicker _imagePicker = ImagePicker();
  bool isImageChanged = false;
  bool isLoading = false;
  final storageRef = FirebaseStorage.instance.ref();

  Future getImageFromGallery() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      isImageChanged = true;
      setState(() {
        widget.buttonFunctionality == ButtonFunctionality.update
            ? _updatedImageUrl = pickedImage.path
            : _imageUrl = pickedImage.path;
      });
    }
  }

  Future uploadImageToFirebaseStorage(pickedImage, onSaveMovie) async {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    setState(() {
      isLoading = true;
    });
    try {
      Reference movieRef = storageRef.child('movie_uploads/$fileName');
      await movieRef.putFile(pickedImage).whenComplete(() async {
        String downloadURL = await movieRef.getDownloadURL();
        widget.onImageUrlChanged!(downloadURL);
        onSaveMovie();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonFunctionality == ButtonFunctionality.update) {
      if (isImageChanged) {
        _imageUrl = _updatedImageUrl;
      } else {
        _imageUrl = widget.imageUrl;
      }
      widget.movieNameController.text = widget.movieName!;
      widget.movieDescriptionController.text = widget.movieDescription!;
      widget.personalRatingController.text = widget.personalRating!.toString();
      widget.imdbRatingController.text = widget.imdbRating!.toString();
    }
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
                        child: widget.buttonFunctionality ==
                                ButtonFunctionality.update
                            ? !isImageChanged
                                ? Image.network(
                                    _imageUrl!,
                                  )
                                : Image.file(
                                    File(_imageUrl!),
                                  )
                            : Image.file(
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
                  text: widget.buttonFunctionality == ButtonFunctionality.add
                      ? "ADD MOVIE"
                      : "UPDATE",
                  onPressed:
                      widget.buttonFunctionality == ButtonFunctionality.add
                          ? () => uploadImageToFirebaseStorage(
                              File(_imageUrl!), widget.onAddMovie!)
                          : isImageChanged
                              ? () => uploadImageToFirebaseStorage(
                                  File(_imageUrl!), widget.onUpdateMovie!)
                              : widget.onUpdateMovie!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
