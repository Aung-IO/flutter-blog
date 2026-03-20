import 'package:flutter/material.dart';
import 'package:flutter_blog/core/constants/app_colors.dart';
import 'package:flutter_blog/pages/home.dart';

void main() => runApp(const FlutterBlogApp());

class FlutterBlogApp extends StatelessWidget {
  const FlutterBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blog',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.appBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
