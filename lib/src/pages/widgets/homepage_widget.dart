import 'package:biblia/src/pages/lists/book.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key, required this.title});

  final String title;

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color.fromARGB(255, 207, 207, 207),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).secondaryHeaderColor,
          ),
          const ListBooksPage(),
        ],
      ),
    );
  }
}
