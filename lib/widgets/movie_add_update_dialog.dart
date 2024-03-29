import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moviflix/enums/enums.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';
import 'package:moviflix/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class MovieAddUpdateDialog extends StatefulWidget {
  MovieAddUpdateDialog({
    super.key,
    required this.buttonFunctionality,
    required this.movieNameController,
    required this.personalRatingController,
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
  final TextEditingController movieDescriptionController;
  final VoidCallback onCancel;

  String? imageUrl;
  final String? movieName;
  final double? personalRating;
  final String? imdbRating;
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
      showErrorToast(message: "$e");
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
    }
    return AlertDialog(
      backgroundColor: MyColors.offWhiteLight,
      content: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextField(
              autofocus: true,
              controller: widget.movieNameController,
              labelText: 'MOVIE NAME',
              fontSize: 12,
            ),
            CustomTextField(
              controller: widget.personalRatingController,
              labelText: 'PERSONAL RATING',
              fontSize: 12,
            ),
            CustomTextField(
              controller: widget.movieDescriptionController,
              labelText: 'DESCRIPTION',
              fontSize: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _imageUrl == null
                    ? const Text('No image selected')
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: widget.buttonFunctionality ==
                                ButtonFunctionality.update
                            ? !isImageChanged
                                ? Image.network(
                                    _imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )
                                : Image.file(
                                    File(_imageUrl!),
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )
                            : Image.file(
                                File(_imageUrl!),
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                              ),
                      ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: getImageFromGallery,
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: MyColors.greyLight,
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
