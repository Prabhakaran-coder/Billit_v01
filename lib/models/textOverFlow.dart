import 'package:flutter/material.dart';

class TextOverflowByChars extends StatelessWidget {
  final String text;
  final int maxCharacters;
  final double fontSize;
  const TextOverflowByChars({super.key, required this.text, required this.maxCharacters,required this.fontSize});

  String _truncateText() {
    if (text.length > maxCharacters) {
      return text.substring(0, maxCharacters);
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _truncateText(),
      maxLines: 1,softWrap: true,// Optional, in case the text exceeds
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}