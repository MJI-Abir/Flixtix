import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/enums/enums.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/movie_add_update_dialog.dart';
import 'package:moviflix/controller/movie_controller.dart';
import 'package:moviflix/widgets/movies_list_tile.dart';
import 'package:moviflix/widgets/rating_widget.dart';

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
  final _auth = FirebaseAuth.instance;
  String moviePlot = '';

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
        backgroundColor: MyColors.offWhiteLight,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: _firestore
              .collection('movies')
              .where('userId', isEqualTo: _auth.currentUser!.uid)
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                  snapshot.data;
              List<QueryDocumentSnapshot> document = querySnapshot!.docs;
              // We need to Convert your documents to Maps to display
              List<Map> movies = document.map((e) => e.data() as Map).toList();
              if (movies.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have not added any movies yet!',
                      style: GoogleFonts.aBeeZee(
                        textStyle: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/sad_kitty.jpg',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                );
              }
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
                    onSeeDetailsPressed: () =>
                        openBottomSheet(context, thisMovie),
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
        backgroundColor: MyColors.greyLight,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: MyColors.offWhiteLight,
        ),
      ),
    );
  }

  Future<dynamic> openBottomSheet(
      BuildContext context, Map<dynamic, dynamic> thisMovie) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: ((context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: MyColors.offWhiteLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sBoxOfHeight10,
                Center(
                  child: Container(
                    height: 7,
                    width: 50,
                    decoration: BoxDecoration(
                      color: MyColors.greyLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                sBoxOfHeight20,
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    '${thisMovie['imageUrl']}',
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                sBoxOfHeight20,
                Flexible(
                  child: Text(
                    '${thisMovie['movieName']}',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                sBoxOfHeight10,
                Row(
                  children: [
                    Text(
                      'Released: ${thisMovie['releasedYear']}',
                      style: smallSubtitleText,
                    ),
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: MyColors.greyLight,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      thisMovie['genre'],
                      style: smallSubtitleText,
                    ),
                  ],
                ),
                sBoxOfHeight10,
                Row(
                  children: [
                    RatingWidget(
                      rating: thisMovie['imdbRating'],
                      icon: Icons.star_rounded,
                      title: 'IMDb Rating',
                    ),
                    const SizedBox(width: 30),
                    // Vertical line to separate the ratings
                    Container(
                      height: 30,
                      width: 2,
                      decoration: BoxDecoration(
                        color: MyColors.greyLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 30),
                    RatingWidget(
                      rating: thisMovie['personalRating'].toString(),
                      title: 'Your Rating',
                      icon: Icons.person_pin_rounded,
                    ),
                  ],
                ),
                sBoxOfHeight20,
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    '${thisMovie['moviePlot']}',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
