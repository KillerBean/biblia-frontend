import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/repos/db/db.dart';
import 'package:biblia/src/repositories/fallback_database_repository.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  DatabaseRetriever.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 7, 85, 0),
        ),
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
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: controller,
            builder: (_, __) {
              return Center(
                child: controller.books.isNotEmpty
                    ? GridView.builder(
                        itemCount: controller.books.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                        ),
                        itemBuilder: (_, index) => Center(
                          child: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                            ),
                            child: Center(
                                child: Text(controller.books[index].name)),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.getBooks(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
