import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/sign_in/components/create_form.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  static String routeName = "/create_screen";

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
          "Nouveau Client",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            
            // Formulaire de création
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CreateForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
