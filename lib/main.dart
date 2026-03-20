import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  String initialRoute = SignInScreen.routeName; // Par défaut vers login

  if (token != null && token.isNotEmpty) {
    final isValid = await isTokenValid(token);
    if (isValid) {
      initialRoute = InitScreen.routeName; // Token valide → page d'accueil
    } else {
      // Token invalide → supprimer et aller vers login
      await prefs.clear();
      initialRoute = SignInScreen.routeName;
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

// Fonction pour vérifier le token avec DIO
Future<bool> isTokenValid(String token) async {
  try {
    final dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.159/jiwekeeakiba/public_html/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    final response = await dio.post(
      '/check-token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    // Si status code 200, le token est valide
    return response.statusCode == 200;
  } on DioException catch (e) {
    // Gestion détaillée des erreurs
    print("Erreur DIO vérification token : ${e.message}");
    
    if (e.response != null) {
      print("Status code: ${e.response!.statusCode}");
      print("Response data: ${e.response!.data}");
    }
    
    return false;
  } catch (e) {
    print("Erreur générale vérification token : $e");
    return false;
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);  // RGB(146, 239, 158)
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);    // RGB(57, 188, 245)
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1); // RGB(34, 70, 109)
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1); // Background RGB(211, 232, 236)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jiwekee Akiba',
      theme: AppTheme.lightTheme(context).copyWith(
        // Adaptation avec les couleurs exactes du logo
        colorScheme: const ColorScheme.light(
          primary: logoDarkBlue,        // Bleu foncé pour éléments principaux
          secondary: logoGreen,         // Vert pour accents
          background: backgroundColor,  // Background général
          surface: backgroundColor,     // Surface des cartes
          onPrimary: Colors.white,
          onSecondary: logoDarkBlue,
          onBackground: logoDarkBlue,   // Texte sur background
          onSurface: logoDarkBlue,      // Texte sur surface
        ),
        
        // AppBar theme avec background RGB(211, 232, 236)
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor, // Même background que le body
          elevation: 0, // Suppression de l'ombre pour un look plat
          iconTheme: IconThemeData(color: logoDarkBlue),
          titleTextStyle: TextStyle(
            color: logoDarkBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        
        // Elevated Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: logoDarkBlue,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        
        // Floating Action Button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: logoBlue,
          foregroundColor: Colors.white,
        ),
        
        // Input Decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Fond blanc pour contraster avec le background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: logoBlue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          labelStyle: const TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: 'Poppins',
          ),
        ),
        
        // Text theme adapté au background
        textTheme: Theme.of(context).textTheme.copyWith(
              headlineMedium: const TextStyle(
                color: logoDarkBlue,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              titleLarge: const TextStyle(
                color: logoDarkBlue,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              bodyLarge: const TextStyle(
                color: logoDarkBlue,
                fontFamily: 'Poppins',
              ),
              bodyMedium: TextStyle(
                color: logoDarkBlue.withOpacity(0.8),
                fontFamily: 'Poppins',
              ),
            ),
        
        // Chip theme
        chipTheme: ChipThemeData(
          backgroundColor: logoGreen.withOpacity(0.2),
          labelStyle: const TextStyle(color: logoDarkBlue),
          selectedColor: logoBlue,
          checkmarkColor: Colors.white,
        ),
        
        // Scaffold background
        scaffoldBackgroundColor: backgroundColor,
        
        // Card theme
        cardTheme: CardTheme(
          color: Colors.white, // Cartes blanches pour contraster
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}