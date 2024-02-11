import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/custom_movie_addition_dialog.dart';
import 'package:moviflix/widgets/movies_list_tile.dart';

class FlixtixPage extends StatefulWidget {
  const FlixtixPage({super.key});

  @override
  State<FlixtixPage> createState() => _FlixtixPageState();
}

class _FlixtixPageState extends State<FlixtixPage> {
  final _imageUrl = "";
  final _movieNameController = TextEditingController();
  final _personalRatingController = TextEditingController();
  final _imdbRatingController = TextEditingController();
  final _movieDescriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<List> moviesList = [
    [
      'inception',
      'description abc',
      8.3,
      8.5,
      'assets/images/animal_cover.png',
    ],
    [
      '12th fail',
      'description good',
      8.0,
      8.4,
      'assets/images/animal_cover.png',
    ],
    [
      'interstellar',
      'description very good',
      8.5,
      8.2,
      'assets/images/animal_cover.png'
    ],
    [
      'once upon a time in mumbai',
      'description',
      7.7,
      6.8,
      'assets/images/animal_cover.png'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flixtix",
          style: TextStyle(fontFamily: "SingleDay"),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: MyColors.appBgColor,
      body: ListView.builder(
        itemCount: moviesList.length,
        itemBuilder: (context, index) {
          return MoviesListTile(
            movieName: moviesList[index][0],
            movieDescription: moviesList[index][1],
            personalRating: moviesList[index][2],
            imdbRating: moviesList[index][3],
            imgPath: moviesList[index][4],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openMovieAdditionDialog,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void openMovieAdditionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomMovieAdditionDialog(
          imageUrl: _imageUrl,
          movieNameController: _movieNameController,
          personalRatingController: _personalRatingController,
          imdbRatingController: _imdbRatingController,
          movieDescriptionController: _movieDescriptionController,
          onAddMovie: () {
            saveMovie(
              _imageUrl,
              _movieNameController,
              _personalRatingController,
              _imdbRatingController,
              _movieDescriptionController,
            );
            _movieNameController.clear();
            _personalRatingController.clear();
            _imdbRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _imdbRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void saveMovie(
    String imageUrl,
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController imdbRatingController,
    TextEditingController movieDescriptionController,
  ) async {
    print("imageUrl : $imageUrl");
    String movieName = movieNameController.text;
    double personalRating = double.parse(personalRatingController.text);
    double imdbRating = double.parse(imdbRatingController.text);
    String movieDescription = movieDescriptionController.text;
    DateTime now = DateTime.now();
    DocumentReference documentReference =
        await _firestore.collection('movies').add({
      'movieName': movieName,
      'personalRating': personalRating,
      'imdbRating': imdbRating,
      'movieDescription': movieDescription,
      'isFavorite': false,
      'imageUrl': imageUrl,
      'timestamp': now,
    });
    String movieId = documentReference.id;
    await _firestore.collection('movies').doc(movieId).update(
      {'id': movieId},
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop;
  }
}
