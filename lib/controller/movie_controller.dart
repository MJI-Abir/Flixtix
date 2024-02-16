import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:http/http.dart' as http;

class MovieController {
  static String _imdbRating = "";
  static Future<void> _getImdbRating(String movieName) async {
    final String apiKey = dotenv.env['API_KEY'] ?? '';

    if (movieName.isEmpty) {
      // Show an error message if the movie name is empty
      return;
    }

    final String apiUrl =
        'https://www.omdbapi.com/?t=$movieName&apikey=$apiKey';

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['Response'] == 'True') {
        // Movie found, extract IMDb rating
        _imdbRating = data['imdbRating'];
      } else {
        // Movie not found, handle accordingly
        _imdbRating = "Not found";
      }
    } else {
      // Error in the API request, handle accordingly
      _imdbRating = "Error";
    }
  }

  static void saveMovie(
    BuildContext context,
    FirebaseFirestore firestore,
    String imageUrl,
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController movieDescriptionController,
  ) async {
    String movieName = movieNameController.text;
    await MovieController._getImdbRating(movieName);
    double personalRating = double.parse(personalRatingController.text);
    String movieDescription = movieDescriptionController.text;
    DateTime now = DateTime.now();
    
    DocumentReference documentReference =
        await firestore.collection('movies').add({
      'movieName': movieName,
      'personalRating': personalRating,
      'imdbRating': MovieController._imdbRating,
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
    movieDescriptionController.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  static Future deleteMovie(
      BuildContext context, FirebaseFirestore firestore, String movieId) async {
    try {
      //deleting the image from firebase storage
      DocumentSnapshot movieSnapshot =
          await firestore.collection('movies').doc(movieId).get();

      if (movieSnapshot.data() != null) {
        String imageUrl =
            (movieSnapshot.data() as Map<String, dynamic>)['imageUrl'];
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      firestore.collection('movies').doc(movieId).delete().then(
            (_) => showToast(message: 'Movie Deleted'),
          );
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
    TextEditingController movieDescriptionController,
    String imageUrl,
    String movieId,
  ) async {
    String movieName = movieNameController.text;
    double personalRating = double.parse(personalRatingController.text);
    String movieDescription = movieDescriptionController.text;

    firestore
        .collection('movies')
        .doc(movieId)
        .update(
          {
            'movieName': movieName,
            'movieDescription': movieDescription,
            'personalRating': personalRating,
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
