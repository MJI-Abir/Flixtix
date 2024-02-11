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
  final _movieNameController = TextEditingController();
  final _personalRatingController = TextEditingController();
  final _imdbRatingController = TextEditingController();
  final _movieDescriptionController = TextEditingController();

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
            movieNameController: _movieNameController,
            personalRatingController: _personalRatingController,
            imdbRatingController: _imdbRatingController,
            movieDescriptionController: _movieDescriptionController,
            onAddMovie: () {},
            onCancel: () {
              _movieNameController.clear();
              _personalRatingController.clear();
              _imdbRatingController.clear();
              _movieDescriptionController.clear();
              Navigator.of(context).pop();
            },
          );
        });
  }
}
