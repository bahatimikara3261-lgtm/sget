import 'package:flutter/material.dart';
import 'package:shop_app/screens/settings/components/change_password_section.dart';

class SecuritySettingsSection extends StatelessWidget {
  const SecuritySettingsSection({super.key});

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: logoDarkBlue, size: 24), // Bleu foncé logo
                const SizedBox(width: 12),
                Text(
                  "Sécurité",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: logoDarkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Section changement de mot de passe
            const ChangePasswordSection(),
          ],
        ),
      ),
    );
  }
}