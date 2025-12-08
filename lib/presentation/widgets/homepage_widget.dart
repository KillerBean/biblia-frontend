import 'package:biblia/core/utils/config_service.dart';
import 'package:biblia/presentation/views/lists/book.dart';
import 'package:biblia/presentation/widgets/search_delegate_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key, required this.title});

  final String title;

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  bool _isApiEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = Modular.get<ConfigService>();
    final enabled = await config.isApiEnabled();
    setState(() {
      _isApiEnabled = enabled;
    });
  }

  Future<void> _toggleApi(bool value) async {
    final config = Modular.get<ConfigService>();
    await config.setApiEnabled(value);
    setState(() {
      _isApiEnabled = value;
    });

    // Show snackbar to inform user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(value ? "Usando API Online" : "Usando Banco de Dados Offline"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
        actions: [
          Row(
            children: [
              const Icon(Icons.cloud_outlined, size: 16, color: Colors.white54),
              Switch(
                value: _isApiEnabled,
                onChanged: _toggleApi,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.greenAccent,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: const Color.fromARGB(255, 207, 207, 207),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BibleSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).secondaryHeaderColor,
          ),
          // Force rebuild when mode changes using Key
          ListBooksPage(key: ValueKey(_isApiEnabled)),
        ],
      ),
    );
  }
}
