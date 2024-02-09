import 'package:flutter/material.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/movies_list_tile.dart';

class FlixtixPage extends StatefulWidget {
  const FlixtixPage({super.key});

  @override
  State<FlixtixPage> createState() => _FlixtixPageState();
}

class _FlixtixPageState extends State<FlixtixPage> {
  final List<List> moviesList = [
    ['inception', 'description abc', 8.3],
    ['12th fail', 'description good', 8.0],
    ['interstellar', 'description very good', 8.5],
    ['once upon a time in mumbai', 'description', 7.7],
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
