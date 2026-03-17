import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        title: 'Artículos de Fútbol',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Fondo suave
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E3A47), // Títulos/Primario
            primary: const Color(0xFF2E3A47),
            secondary: const Color(0xFF6C757D), // Botones
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF333333)), // Texto principal
            bodyMedium: TextStyle(color: Color(0xFF333333)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2E3A47),
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
