// ignore_for_file: unused_field

import 'dart:convert';
import 'package:moviflix/config/config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String _imdbRating = "";
  static String _moviePlot = "";
  static String _releasedYear = "";
  static String _genre = "";

  static Future<void> getMovieData(String movieName) async {
    const String apiKey = Config.apiKey;

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
        _imdbRating = data['imdbRating'];
        _moviePlot = data['Plot'];
        _releasedYear = data['Year'];
        _genre = data['Genre'];
      } else {
        _imdbRating = _genre = _releasedYear = _moviePlot = "Not Found";
      }
    } else {
      _imdbRating = _genre = _releasedYear = _moviePlot = "Error";
    }
  }
}
