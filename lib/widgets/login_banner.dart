import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviflix/utils/my_colors.dart';

class LoginBanner extends StatelessWidget {
  const LoginBanner({
    super.key,
    required this.firstLine,
    required this.secondLine,
  });
  final String firstLine;
  final String secondLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: MyColors.appTheme,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstLine,
              style: GoogleFonts.robotoCondensed(
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              secondLine,
              style: GoogleFonts.robotoCondensed(
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
