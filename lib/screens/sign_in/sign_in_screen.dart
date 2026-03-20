import 'package:flutter/material.dart';

import 'components/sign_form.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({super.key});
  
  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1); // Nouveau background

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
            fontSize: 22,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 2,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: backgroundColor, // Background RGB(211, 232, 236)
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    
                    // Logo Jiwekee Akiba
                    Container(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        "assets/images/logojiwekeeakiba.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    const SizedBox(height: 3),
                    
                    const Text(
                      "Bienvenue à nouveau",
                      style: TextStyle(
                        color: logoDarkBlue, // Retour au bleu foncé pour contraste
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          
                          Text(
                            "Connectez-vous avec votre adresse e-mail et votre mot de passe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec transparence
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    const SignForm(),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}