import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key});
  
  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          "Jiwekee Akiba",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo Jiwekee Akiba
            Container(
              width: 150,
              height: 150,
              child: Image.asset(
                "assets/images/logojiwekeeakiba.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            // Titre principal
            Text(
              "Connexion Réussie !",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: logoDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Sous-titre
            Text(
              "Bienvenue dans votre espace Jiwekee Akiba",
              style: TextStyle(
                fontSize: 16,
                color: logoDarkBlue.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3),
            // Bouton d'action
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    InitScreen.routeName,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: logoDarkBlue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: logoDarkBlue.withOpacity(0.3),
                ),
                child: const Text(
                  "Accéder à mon espace",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}