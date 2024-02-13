import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moviflix/enums/enums.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/movie_add_update_dialog.dart';
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
                    onDelete: (context) => deleteMovie(thisMovie['id']),
                    onEditPressed: (context) => openUpdateMovieDialog(
                      thisMovie['id'],
                      thisMovie['movieName'],
                      thisMovie['personalRating'],
                      thisMovie['imdbRating'],
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

  void openMovieAdditionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MovieAddUpdateDialog(
          buttonFunctionality: ButtonFunctionality.add,
          movieNameController: _movieNameController,
          personalRatingController: _personalRatingController,
          imdbRatingController: _imdbRatingController,
          movieDescriptionController: _movieDescriptionController,
          onImageUrlChanged: (imageUrl) {
            _imageUrl = imageUrl;
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _imdbRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
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
        );
      },
    );
  }

  void openUpdateMovieDialog(
    String movieId,
    String movieName,
    double personalRating,
    double imdbRating,
    String movieDescription,
    String imageUrl,
  ) {
    showDialog(
      context: context,
      builder: ((context) {
        _imageUrl = imageUrl;
        return MovieAddUpdateDialog(
          buttonFunctionality: ButtonFunctionality.update,
          imageUrl: imageUrl,
          movieName: movieName,
          movieDescription: movieDescription,
          personalRating: personalRating,
          imdbRating: imdbRating,
          movieNameController: _movieNameController,
          personalRatingController: _personalRatingController,
          imdbRatingController: _imdbRatingController,
          movieDescriptionController: _movieDescriptionController,
          onImageUrlChanged: (imageUrl) {
            _imageUrl = imageUrl;
          },
          onCancel: () {
            _movieNameController.clear();
            _personalRatingController.clear();
            _imdbRatingController.clear();
            _movieDescriptionController.clear();
            Navigator.of(context).pop();
          },
          onUpdateMovie: () {
            updateMovie(
              _movieNameController,
              _personalRatingController,
              _imdbRatingController,
              _movieDescriptionController,
              _imageUrl,
              movieId,
            );
          },
        );
      }),
    );
  }

  Future saveMovie(
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

  Future deleteMovie(String movieId) async {
    _firestore
        .collection('movies')
        .doc(movieId)
        .delete()
        .then(
          (_) => Fluttertoast.showToast(
            msg: "Movie deleted",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 14.0,
          ),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
            msg: "Failed: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          ),
        );
  }

  Future updateMovie(
    TextEditingController movieNameController,
    TextEditingController personalRatingController,
    TextEditingController imdbRatingController,
    TextEditingController movieDescriptionController,
    String imageUrl,
    String movieId,
  ) async {
    String movieName = movieNameController.text;
    String movieDescription = movieDescriptionController.text;
    double personalRating = double.parse(personalRatingController.text);
    double imdbRating = double.parse(imdbRatingController.text);
    _firestore
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
          (_) => Fluttertoast.showToast(
            msg: "Movie Updated",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.yellow,
            textColor: Colors.black,
            fontSize: 14.0,
          ),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
            msg: "Failed: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0,
          ),
        );
    Navigator.of(context).pop();
  }
}
