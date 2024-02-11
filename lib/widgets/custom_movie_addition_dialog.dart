import 'package:flutter/material.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_material_button.dart';

// ignore: must_be_immutable
class CustomMovieAdditionDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.appBgColor,
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              autofocus: true,
              controller: movieNameController,
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
                    controller: personalRatingController,
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
                    controller: imdbRatingController,
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
              controller: movieDescriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "DESCRIPTION",
                hintStyle: TextStyle(fontSize: 12),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomMaterialButton(
                  text: "CANCEL",
                  onPressed: onCancel,
                ),
                const SizedBox(width: 10),
                CustomMaterialButton(
                  text: "ADD MOVIE",
                  onPressed: onAddMovie,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
