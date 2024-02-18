import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.text,
    required this.svgAssetName,
  });
  final VoidCallback onPressed;
  final IconData iconData;
  final String text;
  final String svgAssetName;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/$svgAssetName',
            semanticsLabel: '$text logo',
            height: 30,
            width: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
