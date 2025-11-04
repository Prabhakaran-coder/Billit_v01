import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
class TextOverflowByCharsInvoice extends StatelessWidget {
  final String text;
 final int maxCharactersPerLine;
  final double fontSize;
  final int maxLines;
  const TextOverflowByCharsInvoice({super.key, required this.text, 
  required this.maxCharactersPerLine,
  required this.fontSize,required this.maxLines});

  // String _truncateText() {
  //   if (text.length > maxCharacters) {
  //     return text.substring(0, maxCharacters);
  //   } else {
  //     return text;
  //   }
  // }
   String _wrapTextByCharacters(String text, int maxCharactersPerLine) {
    StringBuffer wrappedText = StringBuffer();
    for (int i = 0; i < text.length; i += maxCharactersPerLine) {
      wrappedText.write(
          text.substring(i, i + maxCharactersPerLine > text.length ? text.length : i + maxCharactersPerLine));
      if (i + maxCharactersPerLine < text.length) {
        wrappedText.write('\n');
      }
    }
    return wrappedText.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Text(
     _wrapTextByCharacters(text,
    maxCharactersPerLine
     ),
    
      maxLines: maxLines,// Optional, in case the text exceeds
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}
class TextOverflowByCharsInvoicePdf extends StatelessWidget {
   
  final String text;
  final int maxCharactersPerLine;
  final double fontSize;
  final int maxLines;
  const TextOverflowByCharsInvoicePdf({super.key, required this.text, 
  required this.maxCharactersPerLine,
  required this.fontSize,required this.maxLines});

  // String _truncateText() {
  //   if (text.length > maxCharacters) {
  //     return text.substring(0, maxCharacters);
  //   } else {
  //     return text;
  //   }
  // }
   String _wrapTextByCharacters(String text, int maxCharactersPerLine) {
    StringBuffer wrappedText = StringBuffer();
    for (int i = 0; i < text.length; i += maxCharactersPerLine) {
      wrappedText.write(
          text.substring(i, i + maxCharactersPerLine > text.length ? text.length : i + maxCharactersPerLine));
      if (i + maxCharactersPerLine < text.length) {
        wrappedText.write('\n');
      }
    }
    return wrappedText.toString();
  }

  
   @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    return Text(
     _wrapTextByCharacters(text,
    maxCharactersPerLine
     ),
    
      maxLines: maxLines,// Optional, in case the text exceeds
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }
}