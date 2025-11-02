import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 149, 168),
        ),
        useMaterial3: true,
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
