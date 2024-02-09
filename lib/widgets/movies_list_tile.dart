import 'package:flutter/material.dart';
import 'package:moviflix/utils/my_colors.dart';

class MoviesListTile extends StatelessWidget {
  const MoviesListTile({
    super.key,
    required this.movieName,
    required this.movieDescription,
    required this.personalRating,
  });

  final String movieName;
  final String movieDescription;
  final double personalRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25, right: 25, top: 12.5, bottom: 12.5),
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.appTheme,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: MyColors.cardShadowColor,
              blurRadius: 5.0,
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
                child: Image.asset(
                  'assets/images/animal_cover.png',
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
                  Text(
                    movieName,
                    style: const TextStyle(
                      fontFamily: 'SingleDay',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Personal Rating: $personalRating',
                    style: const TextStyle(
                      fontFamily: 'PoorStory',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    splashFactory: InkSplash.splashFactory,
                    onTap: () {},
                    child: const Icon(Icons.favorite_border_outlined),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
