import 'dart:ffi';

import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/repos/db/db.dart';
import 'package:biblia/src/repositories/fallback_database_repository.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await DatabaseRetriever.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 0, 160)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final controller = DatabaseController(FallbackDatabaseRepository());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: GridView.builder(
              itemCount: controller.books.length,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (_, index) => Center(
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.red,
                      // tileColor: Colors.red,
                      // key: UniqueKey(),
                      child: Center(child: Text(controller.books[index].name)),
                      // title: Center(child: Text(controller.books[index].name)),
                    ),
                  ))
          // ListView.builder(
          //   itemCount: controller.books.length,
          //   itemBuilder: (_, index) => ListTile(
          //     leading: CircleAvatar(
          //       child: Center(
          //         child: Text("${controller.books[index].bookReferenceId}"),
          //       ),
          //     ),
          //     key: UniqueKey(),
          //     title: Text(controller.books[index].name),
          //   ),
          // ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getBooks(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
