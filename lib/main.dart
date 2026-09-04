import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eInspect',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('Placeholder')),
      ),
    );
  }
}
