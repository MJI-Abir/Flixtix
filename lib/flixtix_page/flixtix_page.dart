import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moviflix/enums/enums.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/movie_add_update_dialog.dart';
import 'package:moviflix/controller/movie_controller.dart';
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
  final _movieDescriptionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void openMovieAdditionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MovieAddUpdateDialog(
          buttonFunctionality: ButtonFunctionality.add,
          movieNameController: _movieNameController,
          personalRatingController: _personalRatingController,
          movieDescriptionController: _movieDescriptionController,
          onImageUrlChanged: (imageUrl) {
            _imageUrl = imageUrl;
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
          onAddMovie: () {
            MovieController.saveMovie(
              context,
              _firestore,
              _imageUrl,
              _movieNameController,
              _personalRatingController,
              _movieDescriptionController,
            );
          },
        );
      },
    );
  }

  void openUpdateMovieDialog(
    String movieId,
    String movieName,
    double personalRating,
    String movieDescription,
    String imageUrl,
  ) {
    showDialog(
      context: context,
      builder: ((context) {
        _imageUrl = imageUrl;
        return MovieAddUpdateDialog(
          buttonFunctionality: ButtonFunctionality.update,
          movieName: movieName,
          personalRating: personalRating,
          movieDescription: movieDescription,
          imageUrl: imageUrl,
          movieNameController: _movieNameController,
          personalRatingController: _personalRatingController,
          movieDescriptionController: _movieDescriptionController,
          onImageUrlChanged: (imageUrl) {
            _imageUrl = imageUrl;
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
          onUpdateMovie: () {
            MovieController.updateMovie(
              context,
              _firestore,
              _movieNameController,
              _personalRatingController,
              _movieDescriptionController,
              _imageUrl,
              movieId,
            );
          },
        );
      }),
    );
  }

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
                    timestamp: thisMovie['timestamp'],
                    onDelete: (context) => MovieController.deleteMovie(
                      context,
                      _firestore,
                      thisMovie['id'],
                    ),
                    onEditPressed: (context) => openUpdateMovieDialog(
                      thisMovie['id'],
                      thisMovie['movieName'],
                      thisMovie['personalRating'],
                      thisMovie['movieDescription'],
                      thisMovie['imageUrl'],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black87),
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
}
