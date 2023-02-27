import 'package:flutter/material.dart';

class BaseTemplate extends StatefulWidget {
  final Widget screenContent;
  final String pageTitle;
  const BaseTemplate(
      {super.key, required this.screenContent, required this.pageTitle});

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
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Bookmarks',
          icon: Icon(Icons.bookmark),
        ),
      ]),
    );
  }
}
