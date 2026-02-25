import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/database/database_service.dart';
import 'package:pos_app/screens/product_form.dart';
import 'package:pos_app/screens/product_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarThemeData(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5, 
            vertical: 12
          ),
        ),
      ),
      
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductList(),
        '/menu': (context) => const ProductList(),
        'product_form': (context) => const ProductForm(),
      },
    );
  }
}