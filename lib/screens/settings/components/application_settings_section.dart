import 'package:flutter/material.dart';

class ApplicationSettingsSection extends StatelessWidget {
  const ApplicationSettingsSection({super.key});

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
                Icon(Icons.settings, color: logoDarkBlue, size: 24), // Bleu foncé logo
                const SizedBox(width: 12),
                Text(
                  "Application",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: logoDarkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSettingItem(
              icon: Icons.notifications,
              title: "Notifications",
              subtitle: "Gérer les notifications push",
              onTap: () {
                // Navigation vers les paramètres de notifications
              },
            ),
            const Divider(height: 20),
            _buildSettingItem(
              icon: Icons.language,
              title: "Langue",
              subtitle: "Français",
              onTap: () {
                // Changer la langue
              },
            ),
            const Divider(height: 20),
            _buildSettingItem(
              icon: Icons.help,
              title: "Centre d'aide",
              subtitle: "FAQ et support",
              onTap: () {
                // Navigation vers l'aide
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: logoBlue.withOpacity(0.1), // Bleu logo avec transparence
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: logoBlue, size: 20), // Bleu logo
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: logoDarkBlue,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: logoDarkBlue.withOpacity(0.6), 
          fontSize: 12
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: logoDarkBlue.withOpacity(0.3)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}