import 'package:flutter/material.dart';
import 'package:moviflix/utils/commons.dart';
import 'package:moviflix/utils/my_colors.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rating,
    required this.title,
    required this.icon,
  });

  final String rating;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: smallSubtitleText,
        ),
        Row(
          children: [
            Icon(
              icon,
              color: MyColors.greyLight,
            ),
            const SizedBox(width: 5),
            Text(
              rating,
              style: const TextStyle(
                fontFamily: 'PoorStory',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyColors.greyLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
