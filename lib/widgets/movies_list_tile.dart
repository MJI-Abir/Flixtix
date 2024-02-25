import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/consts.dart';
import 'package:moviflix/utils/my_colors.dart';
import 'package:moviflix/widgets/rating_widget.dart';

class MoviesListTile extends StatelessWidget {
  const MoviesListTile({
    super.key,
    required this.movieName,
    required this.movieDescription,
    required this.personalRating,
    required this.imdbRating,
    required this.imgPath,
    required this.onDelete,
    required this.onEditPressed,
    required this.onSeeDetailsPressed,
    required this.timestamp,
  });
  final String movieName;
  final String movieDescription;
  final double personalRating;
  final String imdbRating;
  final String imgPath;
  final Timestamp timestamp;

  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEditPressed;
  final VoidCallback onSeeDetailsPressed;
  @override
  Widget build(BuildContext context) {
    var formattedDate =
        '${timestamp.toDate().day}-${timestamp.toDate().month}-${timestamp.toDate().year}';
    return Padding(
      padding:
           const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: 7.5, bottom: 7.5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: onEditPressed,
              icon: Icons.edit,
              backgroundColor: MyColors.greyLight,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.offWhiteLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: MyColors.offWhiteLight,
                blurRadius: 2.0,
                offset: Offset(0, 5), // shadow direction: bottom right
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imgPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 6,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Text(
                        movieName,
                        style: GoogleFonts.robotoCondensed(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        RatingWidget(
                          rating: personalRating.toString(),
                          title: "Your Rating",
                          icon: Icons.person_pin_rounded,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        RatingWidget(
                          rating: imdbRating,
                          title: 'IMDB Rating',
                          icon: Icons.star_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        InkWell(
                          splashFactory: InkSplash.splashFactory,
                          onTap: () {},
                          child: const Icon(Icons.favorite_border_outlined),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Added on: $formattedDate',
                          style: smallSubtitleText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSeeDetailsPressed,
                icon: const Icon(Icons.report_gmailerrorred),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
