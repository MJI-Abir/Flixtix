import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moviflix/config/config.dart';
import 'package:moviflix/widgets/custom_material_button.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _movieNameController = TextEditingController();
  String _imdbRating = "";

  Future<void> _getImdbRating() async {
    const String apiKey = Config.apiKey; // Replace with your actual API key
    final String movieName = _movieNameController.text.trim();

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
        setState(() {
          _imdbRating = data['imdbRating'];
        });
      } else {
        // Movie not found, handle accordingly
        setState(() {
          _imdbRating = 'Not found';
        });
      }
    } else {
      // Error in the API request, handle accordingly
      setState(() {
        _imdbRating = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _movieNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Movie Name",
            ),
          ),
          Text('IMDB Rating: $_imdbRating'),
          CustomMaterialButton(
              text: "GET IMDB RATING", onPressed: _getImdbRating),
        ],
      ),
    );
  }
}
