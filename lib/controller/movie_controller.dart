import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/utils/commons.dart';

class MovieController {
  static void saveMovie(
    BuildContext context,
    FirebaseFirestore firestore,
    String imageUrl,
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController imdbRatingController,
    TextEditingController movieDescriptionController,
  ) async {
    String movieName = movieNameController.text;
    double personalRating = double.parse(personalRatingController.text);
    double imdbRating = double.parse(imdbRatingController.text);
    String movieDescription = movieDescriptionController.text;
    DateTime now = DateTime.now();
    DocumentReference documentReference =
        await firestore.collection('movies').add({
      'movieName': movieName,
      'personalRating': personalRating,
      'imdbRating': imdbRating,
      'movieDescription': movieDescription,
      'isFavorite': false,
      'imageUrl': imageUrl,
      'timestamp': now,
    });
    String movieId = documentReference.id;
    await firestore
        .collection('movies')
        .doc(movieId)
        .update(
          {'id': movieId},
        )
        .then(
          (_) => showToast(message: 'Movie Added'),
        )
        .catchError(
          (error) => showToast(message: 'Failed : $error'),
        );
    movieNameController.clear();
    personalRatingController.clear();
    imdbRatingController.clear();
    movieDescriptionController.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  static Future deleteMovie(
      BuildContext context, FirebaseFirestore firestore, String movieId) async {
    try {
      firestore.collection('movies').doc(movieId).delete().then(
            (_) => showToast(message: 'Movie Deleted'),
          );
      //deleting the image from firebase storage
      // DocumentSnapshot movieSnapshot =
      //     await firestore.collection('movies').doc(movieId).get();

      // if (movieSnapshot.data() != null) {
      //   String imageUrl =
      //       (movieSnapshot.data() as Map<String, dynamic>)['imageUrl'];
      //   await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      // }
    } catch (error) {
      showToast(
        message: "Failed: $error",
      );
    }
  }

  static Future updateMovie(
    BuildContext context,
    FirebaseFirestore firestore,
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController imdbRatingController,
    TextEditingController movieDescriptionController,
    String imageUrl,
    String movieId,
  ) async {
    String movieName = movieNameController.text;
    double personalRating = double.parse(personalRatingController.text);
    double imdbRating = double.parse(imdbRatingController.text);
    String movieDescription = movieDescriptionController.text;

    firestore
        .collection('movies')
        .doc(movieId)
        .update(
          {
            'movieName': movieName,
            'movieDescription': movieDescription,
            'personalRating': personalRating,
            'imdbRating': imdbRating,
            'imageUrl': imageUrl,
          },
        )
        .then(
          (_) => showToast(message: "Movie Updated"),
        )
        .catchError(
          (error) => showToast(message: 'Failed: $error'),
        );
    Navigator.of(context).pop();
  }
}
