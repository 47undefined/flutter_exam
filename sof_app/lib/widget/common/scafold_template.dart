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
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  index == 0 ? const Homepage() : const UserBookmark(),
            ),
          );
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Bookmarks',
            icon: Icon(
              Icons.bookmark,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
