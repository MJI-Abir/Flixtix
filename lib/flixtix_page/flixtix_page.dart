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
  String _imageUrl = "";
  final _movieNameController = TextEditingController();
  final _personalRatingController = TextEditingController();
  final _imdbRatingController = TextEditingController();
  final _movieDescriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flixtix",
          style: TextStyle(
            fontFamily: "SingleDay",
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: MyColors.appBgColor,
      body: StreamBuilder(
          stream:
              _firestore.collection('movies').orderBy('timestamp').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                  snapshot.data;
              List<QueryDocumentSnapshot> document = querySnapshot!.docs;

              // We need to Convert your documents to Maps to display
              List<Map> movies = document.map((e) => e.data() as Map).toList();
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  Map thisMovie = movies[index];
                  return MoviesListTile(
                    movieName: thisMovie['movieName'],
                    movieDescription: thisMovie['movieDescription'],
                    personalRating: thisMovie['personalRating'],
                    imdbRating: thisMovie['imdbRating'],
                    imgPath: thisMovie['imageUrl'],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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
            _imageUrl = "";
            Navigator.of(context).pop();
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _imdbRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
          onImageUrlChanged: (imageUrl) {
            _imageUrl = imageUrl;
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
  }
}
