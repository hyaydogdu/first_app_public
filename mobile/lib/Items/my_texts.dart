import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

enum TextCaseMode { sentence, title, upper, lower }

class StatBox extends StatelessWidget {
  // workout_done_page'da kullanılıyor
  final String text;
  final String stat;
  final TextStyle? textStyle;
  const StatBox({
    super.key,
    required this.text,
    required this.stat,
    this.textStyle,
  });
  @override
  Widget build(BuildContext context) {
    return BorderBox(
      boxColor: Colors.transparent,
      softCorners: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: defaultHeight / 2),
          Box(edgeSpaceHorizontal: true, child: Text(stat, style: textStyleM)),
          Box(edgeSpaceHorizontal: true, child: Text(text, style: textStyleS)),
          SizedBox(height: defaultHeight / 2),
        ],
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle? textStyle;
  final TextCaseMode? caseMode;
  final double? verticalPadding;
  final double? horizontalPadding;
  const TextBox({
    super.key,
    required this.text,
    required this.color,
    this.textStyle,
    this.caseMode,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color,
      edgeSpaceHorizontal: true,
      softCorners: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 20,
          vertical: verticalPadding ?? 4,
        ),
        child: Text(
          caseMode != null ? textCase(text, caseMode!) : text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class EditText extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? hint;

  const EditText({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      boxColor: color_1,
      child: Column(
        children: [
          TextBox(text: label, textStyle: textStyleM, color: color_1),
          BorderBox(
            edgeSpaceHorizontal: true,
            edgeSpaceAllSmall: true,
            boxColor: color_1,
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none, // ❗ TextBox border'ı kullansın
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String textCase(String input, TextCaseMode mode) {
  switch (mode) {
    case TextCaseMode.upper:
      return input.toUpperCase();

    case TextCaseMode.lower:
      return input.toLowerCase();

    case TextCaseMode.title:
      final lower = input.toLowerCase();
      final buffer = StringBuffer();
      var capitalizeNext = true;

      for (int i = 0; i < lower.length; i++) {
        final ch = lower[i];

        if (ch.trim().isEmpty) {
          buffer.write(ch);
          capitalizeNext = true;
          continue;
        }

        if (capitalizeNext) {
          buffer.write(ch.toUpperCase());
          capitalizeNext = false;
        } else {
          buffer.write(ch);
        }
      }

      return buffer.toString();

    case TextCaseMode.sentence:
      if (input.isEmpty) return input;

      final lower = input.toLowerCase();
      final buffer = StringBuffer();

      bool capitalizeNext = true; // başlangıçta ilk harf büyük

      for (int i = 0; i < lower.length; i++) {
        final ch = lower[i];

        // Cümle bitiş işaretleri → sonraki harf büyük
        if (ch == '.' || ch == '!' || ch == '?') {
          buffer.write(ch);
          capitalizeNext = true;
          continue;
        }

        // Harf mi? (basit kontrol: a-z, Türkçe için ekstra ekleyebilirsin)
        final isLetter = RegExp(r'[a-zA-Zğüşöçıİ]').hasMatch(ch);

        if (capitalizeNext && isLetter) {
          buffer.write(ch.toUpperCase());
          capitalizeNext = false;
        } else {
          buffer.write(ch);
        }

        // Harf gelene kadar capitalizeNext true kalır (boşluk, newline vs. geçilir)
      }

      return buffer.toString();
  }
}
