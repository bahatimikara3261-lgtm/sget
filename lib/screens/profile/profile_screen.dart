import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/account/account_screen.dart';
import 'package:shop_app/screens/settings/settings_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import 'components/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await _apiService.getbalance();

      if (mounted) {
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _loadUserData();
  }

  // Méthode pour construire l'URL de l'image de profil
  String _getProfileImageUrl(String? userAvatar) {
    final String baseUrl = _apiService.baseUrl;
    if (userAvatar != null && userAvatar.isNotEmpty) {
      return '$baseUrl/storage/userprofil/$userAvatar';
    } else {
      return '$baseUrl/storage/userprofil/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background Jiwekee Akiba
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0, // Pas d'ombre pour un look plat
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: _buildProfileContent(context),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(logoDarkBlue),
            ),
            SizedBox(height: 16),
            Text(
              'Chargement du profil...',
              style: TextStyle(color: logoDarkBlue),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: logoBlue, size: 50),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: logoDarkBlue.withOpacity(0.7)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoDarkBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Section profil avec données dynamiques
            _buildProfileHeader(),
            const SizedBox(height: 20),
            // Menu options
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final user = _userData?['users'] ?? {};
    final userName = user['name'] ?? 'Non renseigné';
    final userEmail = user['email'] ?? 'Non renseigné';
    final userRole = user['roles']?[0]?['name'] ?? 'Membre';
    final userPhone = user['tel'] ?? 'Non renseigné';
    final userAvatar = user['avatar'];

    final String profileImageUrl = _getProfileImageUrl(userAvatar);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [logoDarkBlue, logoBlue], // Dégradé bleu foncé → bleu logo
        ),
      ),
      child: Column(
        children: [
          // Image de profil dynamique
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: logoDarkBlue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(profileImageUrl),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Erreur chargement image: $exception');
                  },
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: logoGreen, // Vert logo pour le badge
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt,
                      size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nom de l'utilisateur
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Email
          Text(
            userEmail,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          // Téléphone
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              userPhone,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Badge statut
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: logoGreen.withOpacity(0.9), // Vert logo pour le badge
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              userRole,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Informations supplémentaires (optionnelles)
          if (_userData?['balancecdf'] != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                      'Solde Fc', '${_userData?['balancecdf'] ?? 0} Fc'),
                  _buildStatItem(
                      'Solde \$', '${_userData?['balanceusd'] ?? 0} \$'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Section titre
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              "PARAMÈTRES",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: logoDarkBlue.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Options du menu
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ProfileMenu(
                  text: "Mon compte",
                  icon: "assets/icons/User Icon.svg",
                  press: () {
                    Navigator.pushNamed(context, AccountScreen.routeName);
                  },
                ),
                const Divider(height: 1, indent: 20),
                ProfileMenu(
                  text: "Notifications",
                  icon: "assets/icons/Bell.svg",
                  press: () {},
                ),
                const Divider(height: 1, indent: 20),
                ProfileMenu(
                  text: "Paramètres",
                  icon: "assets/icons/Settings.svg",
                  press: () {
                    Navigator.pushNamed(context, SettingsScreen.routeName);
                  },
                ),
                const Divider(height: 1, indent: 20),
                ProfileMenu(
                  text: "Centre d'aide",
                  icon: "assets/icons/Question mark.svg",
                  press: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Déconnexion
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ProfileMenu(
              text: "Déconnexion",
              icon: "assets/icons/Log out.svg",
              press: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInScreen.routeName,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}