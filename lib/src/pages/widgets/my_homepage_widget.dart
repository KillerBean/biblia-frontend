import 'package:biblia/src/pages/lists/book.dart';
import 'package:flutter/material.dart';

class MyHomePageWidget extends StatefulWidget {
  const MyHomePageWidget({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageWidget> createState() => _MyHomePageWidgetState();
}

class _MyHomePageWidgetState extends State<MyHomePageWidget> {
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
