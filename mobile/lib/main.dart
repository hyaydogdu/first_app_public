import 'package:flutter/material.dart';
import 'package:first_app/Pages/Barrel/page_barrel.dart';
import 'package:first_app/Items/Barrel/item_barrel.dart';

void main() {
  runApp(MainPage());
}

int myIndex = 0;
int previousIndex = 0;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<DefaultPage> widgetList = const [
    HomePage(key: ValueKey("Home Page")),
    CreatePage(key: ValueKey("Creator Page")),
    LibraryPage(key: ValueKey("Library Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: color_1,

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: color_1,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(75),
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0, -1), // yukarı doğru gölge
              ),
            ],
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                previousIndex = myIndex;
                myIndex = index;
              });
            },
            currentIndex: myIndex,
            showUnselectedLabels: false,
            selectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            backgroundColor: color_2,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, color: Colors.black),
                label: "Creator",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, color: Colors.black),
                label: "Library",
              ),
            ],
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final bool isForward = myIndex > previousIndex;

            final offsetAnimation =
                Tween<Offset>(
                  begin: isForward ? Offset(0.75, 0) : Offset(-0.75, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn, // girdi animasyonu
                    reverseCurve: Curves.elasticOut, // çıktısı daha hızlı
                  ),
                );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: widgetList[myIndex],
        ),
      ),
    );
  }
}
