import 'package:biblia/core/di/book_module.dart';
import 'package:biblia/presentation/widgets/main_app_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WakelockPlus.enable();
  runApp(ModularApp(module: appModule, child: const MainAppWidget()));
}

final appModule = createModule(register: (c) {
  c.module(bookModule);
});
