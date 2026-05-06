import 'package:first_app/Services/api_config.dart';
import 'package:flutter/material.dart';

Widget maxWidth({required Widget child}) {
  return SizedBox(width: double.infinity, child: child);
}

Widget imageDisplayer(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.network(
      ApiConfig.endpoint(imageUrl),
      height: 56,
      width: 56,
      fit: BoxFit.cover,
    ),
  );
}
