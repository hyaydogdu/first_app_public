import 'package:flutter/material.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

class LibraryPage extends DefaultPage {
  const LibraryPage({super.key});

  @override
  String get pageName => "Library";
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: color_1,
        appBar: AppBar(backgroundColor: color_1, elevation: 0),
        body: Column(
          children: [
            CreateCard(text: "Library"),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
