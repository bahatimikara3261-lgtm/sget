import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_in/components/deposit_form.dart';

class DepositsScreen extends StatelessWidget {
  const DepositsScreen({super.key});

  static String routeName = "/deposits_screen";

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
          "Dépôt Client",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0,
      ),
      body: const SafeArea(
        child: DepositForm(), // Directement le formulaire
      ),
    );
  }
}