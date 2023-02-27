import 'package:flutter/material.dart';
import 'package:sof_app/screens/homepage.dart';
import 'package:sof_app/screens/sofuser_bookmark.dart';

class BaseTemplate extends StatefulWidget {
  final Widget screenContent;
  final String pageTitle;
  final int tabActiveIndex;
  const BaseTemplate(
      {super.key,
      required this.screenContent,
      required this.pageTitle,
      required this.tabActiveIndex});

  @override
  State<BaseTemplate> createState() => _BaseTemplateState();
}

class _BaseTemplateState extends State<BaseTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle),
      ),
      body: widget.screenContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.tabActiveIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              },
              child: const Icon(Icons.home),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Bookmarks',
            icon: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserBookmark(),
                  ),
                );
              },
              child: const Icon(Icons.bookmark),
            ),
          ),
        ],
      ),
    );
  }
}
