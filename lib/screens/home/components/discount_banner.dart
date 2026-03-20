import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({super.key});

  @override
  _DiscountBannerState createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  late Future<Map<String, dynamic>> _futureUserData;
  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  void initState() {
    super.initState();
    _futureUserData = _apiService.getbalance(); // Utilisation DIO
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20, // Augmenté pour mieux respirer
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            logoDarkBlue, // RGB(34, 70, 109)
            logoBlue,     // RGB(57, 188, 245)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: logoBlue.withOpacity(0.3), // Ombre bleu logo
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingContent();
          }

          if (snapshot.hasError) {
            return _ErrorContent(error: snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return const _ErrorContent(error: 'Aucune donnée disponible');
          }

          final data = snapshot.data!;
          final user = data['users'];
          
          return _UserContent(user: user, data: data);
        },
      ),
    );
  }
}

// Widget pour l'état de chargement
class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(width: 16),
        Text(
          "Chargement...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Widget pour l'état d'erreur
class _ErrorContent extends StatelessWidget {
  final String error;
  const _ErrorContent({required this.error});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Erreur: ${error.length > 50 ? '${error.substring(0, 50)}...' : error}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

// Widget pour le contenu utilisateur
class _UserContent extends StatelessWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> data;
  
  const _UserContent({
    required this.user,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        const Text(
          "Jiwekee Akiba",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        
        // Nom de l'utilisateur
        Text(
          "Bienvenue ${user['name'] ?? 'Utilisateur'}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        
        // Slogan
        Text(
          "Ton avenir commence ici",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        
        // Solde actuel (optionnel)
        if (data['balancecdf'] != null)
          Text(
            "Solde: ${data['balancecdf']} Fc",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}