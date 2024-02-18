import 'package:flutter/material.dart';
import 'package:moviflix/utils/commons.dart';

class TextInBetweenDivider extends StatelessWidget {
  const TextInBetweenDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(),
        ),
        Text(
          '  Or login with  ',
          style: smallSubtitleText,
        ),
        const Expanded(
          child: Divider(),
        ),
      ],
    );
  }
}
