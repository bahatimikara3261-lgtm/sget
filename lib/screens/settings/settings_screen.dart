import 'package:flutter/material.dart';
import 'package:shop_app/screens/settings/components/application_settings_section.dart';
import 'package:shop_app/screens/settings/components/change_password_section.dart';
import 'package:shop_app/screens/settings/components/profile_settings_section.dart';
import 'package:shop_app/screens/settings/components/security_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";

  const SettingsScreen({super.key});

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background Jiwekee Akiba
      appBar: AppBar(
        title: const Text(
          "Paramètres",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0, // Pas d'ombre pour un look plat
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Section profil
            ProfileSettingsSection(),
            SizedBox(height: 20),
            
            // Section sécurité
            SecuritySettingsSection(),
            SizedBox(height: 20),
            
            // Section application
            ApplicationSettingsSection(),
          ],
        ),
      ),
    );
  }
}