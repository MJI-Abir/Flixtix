import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/rating_widget.dart';

class CustomMovieBottomSheet {
  static Future<dynamic> openMovieDetailsBottomSheet(
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
