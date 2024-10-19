import 'package:biblia/src/controllers/database_controller.dart';
import 'package:biblia/src/pages/widgets/my_homepage_widget.dart';
import 'package:biblia/src/repos/db/db.dart';
import 'package:biblia/src/repositories/database_repository.dart';
import 'package:biblia/src/repositories/fallback_database_repository.dart';
import 'package:biblia/src/widgets/main_app_widget.dart';
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
  void binds(i) {
    i.addSingleton(DatabaseRetriever.instance.loadDatabase);
    i.add<DatabaseRepository>(FallbackDatabaseRepository.new);
    i.add(DatabaseController.new);
  }

  @override
  void routes(r) {
    r.child('/',
        child: (context) =>
            const MyHomePageWidget(title: 'Flutter Demo Home Page'));
  }
}
