import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/presentation/pages/catalog_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: JellycatApp(),
    ),
  );
}

class JellycatApp extends StatelessWidget {
  const JellycatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jellycat Tracker',
      theme: AppTheme.lightTheme,
      home: const CatalogPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
