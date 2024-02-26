import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/service/api_service.dart';
import 'package:moviflix/utils/commons.dart';

class FirebaseService {
  static const String _imdbRating = "";
  static const String _moviePlot = "";
  static const String _releasedYear = "";
  static const String _genre = "";
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;


  //-------------FOR TASKS DATABASE-------------//
  static Future updateTask(BuildContext context,
      TextEditingController taskNameController, String taskId) async {
    String taskName = taskNameController.text;
    _firestore
        .collection('tasks')
        .doc(taskId)
        .update({'taskName': taskName})
        .then(
          (_) => showToast(
            message: "Task updated successfully",
          ),
        )
        .catchError(
          (error) => showToast(
            message: "Failed: $error",
          ),
        );
    Navigator.of(context).pop();
  }

  static Future deleteTask(String taskId) async {
    _firestore
        .collection('tasks')
        .doc(taskId)
        .delete()
        .then(
          (_) => showToast(
            message: "Task deleted successfully",
          ),
        )
        .catchError(
          (error) => showToast(
            message: "Failed: $error",
          ),
        );
  }

  static void checkboxChanged(String taskId, bool? value) async {
    await _firestore.collection('tasks').doc(taskId).update(
      {'isCompleted': value},
    );
  }

  //-----------FOR MOVIES DATABASE-----------//

  static void saveMovie(
    BuildContext context,
    FirebaseFirestore firestore,
    String imageUrl,
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController movieDescriptionController,
  ) async {
    String movieName = movieNameController.text;
    await ApiService.getMovieData(movieName);
    double personalRating = double.parse(personalRatingController.text);
    String movieDescription = movieDescriptionController.text;
    DateTime now = DateTime.now();

    DocumentReference documentReference =
        await firestore.collection('movies').add({
      'movieName': movieName,
      'personalRating': personalRating,
      'imdbRating': FirebaseService._imdbRating,
      'moviePlot': FirebaseService._moviePlot,
      'releasedYear': FirebaseService._releasedYear,
      'genre': FirebaseService._genre,
      'movieDescription': movieDescription,
      'isFavorite': false,
      'imageUrl': imageUrl,
      'timestamp': now,
      'userId': _auth.currentUser!.uid,
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
          (error) => showErrorToast(message: 'Failed : $error'),
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
      showErrorToast(
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
          (error) => showErrorToast(message: 'Failed: $error'),
        );
    movieNameController.clear();
    personalRatingController.clear();
    movieDescriptionController.clear();
    Navigator.of(context).pop();
  }
}
