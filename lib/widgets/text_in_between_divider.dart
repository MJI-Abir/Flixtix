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
          flex: 3,
          child: Divider(),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '  Or login with  ',
            style: smallSubtitleText,
          ),
        ),
        const Expanded(
          flex: 3,
          child: Divider(),
        ),
      ],
    );
  }
}
