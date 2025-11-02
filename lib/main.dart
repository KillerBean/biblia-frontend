import 'package:biblia/core/di/book_module.dart';
import 'package:biblia/presentation/widgets/main_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  runApp(ModularApp(module: AppModule(), child: const MainAppWidget()));
}

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module("/", module: BookModule());
  }
}