import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

class AccountScreen extends StatefulWidget {
  static String routeName = "/account";

  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ApiService _apiService = ApiService(); // Instance DIO
  
  // Variables pour stocker les données de l'API
  String _name = "Non renseigné";
  String _email = "Non renseigné";
  String _phone = "Non renseigné";
  String _balanceFc = "0 Fc";
  String _balanceUsd = "0 \$";
  String _walletFc = "0 Fc";
  String _walletUsd = "0 \$";
  String _balanceCarnet = "0 Fc";
  String _resteCarnet = "0";
  String _role = "Membre";
  String? _userAvatar;
  
  bool _isLoading = false;
  String _errorMessage = '';

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  void initState() {
    super.initState();
    // Appeler l'API au chargement de l'écran
    _fetchUserData();
  }

  // Méthode pour récupérer les données de l'API
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await _apiService.getbalance(); // Appel API DIO
      
      if (data['users'] != null) {
        final user = data['users'];
        
        setState(() {
          _name = user['name'] ?? "Non renseigné";
          _email = user['email'] ?? "Non renseigné";
          _phone = user['tel'] ?? "Non renseigné";
          _balanceFc = "${data['balancecdf'] ?? 0} Fc";
          _balanceUsd = "${data['balanceusd'] ?? 0} \$";
          _walletFc = "${user['wallet_cdf'] ?? 0} Fc";
          _walletUsd = "${user['wallet_usd'] ?? 0} \$";
          _balanceCarnet = "${data['balancecarnet'] ?? 0} Fc";
          _resteCarnet = "${data['restecarnet'] ?? 0}";
          _role = user['roles']?[0]?['name'] ?? "Membre";
          _userAvatar = user['avatar'];
        });
      } else {
        setState(() {
          _errorMessage = "Données utilisateur non disponibles";
        });
      }

    } catch (error) {
      setState(() {
        _errorMessage = "Erreur de chargement: ${error.toString().replaceFirst('Exception: ', '')}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Méthode pour rafraîchir les données
  Future<void> _refreshData() async {
    await _fetchUserData();
  }

  // Méthode pour construire l'URL de l'image de profil
  String _getProfileImageUrl() {
    final String baseUrl = _apiService.baseUrl;
    if (_userAvatar != null && _userAvatar!.isNotEmpty) {
      return '$baseUrl/storage/userprofil/$_userAvatar';
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
          "Mon Compte",
          style: TextStyle(
            color: logoDarkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0,
        actions: [
          // Bouton de rafraîchissement
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              'Chargement des données...',
              style: TextStyle(color: logoDarkBlue),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: logoBlue, size: 50),
            const SizedBox(height: 16),
            Text(
              _errorMessage, 
              textAlign: TextAlign.center,
              style: TextStyle(color: logoDarkBlue),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte profil
            _buildProfileCard(),
            const SizedBox(height: 20),
            
            // Section Balances
            _buildBalanceSection(),
            const SizedBox(height: 20),
            
            // Section Portefeuilles
            _buildWalletSection(),
            const SizedBox(height: 20),
            
            // Section Informations personnelles
            _buildPersonalInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final String profileImageUrl = _getProfileImageUrl();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [logoDarkBlue, logoBlue], // Dégradé bleu foncé → bleu logo
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Avatar dynamique
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: NetworkImage(profileImageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  print('Erreur chargement image: $exception');
                },
                child: _userAvatar == null 
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            
            // Nom
            Text(
              _name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Email
            Text(
              _email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
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
                _role,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre section
            Text(
              "BALANCES",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: logoDarkBlue.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Solde en Francs Congolais
            _buildWalletItem(
              icon: Icons.account_balance_wallet,
              title: "Solde en Francs Congolais",
              amount: _balanceFc,
              color: logoGreen, // Vert logo
            ),
            const Divider(height: 24),
            
            // Solde en Dollars
            _buildWalletItem(
              icon: Icons.attach_money,
              title: "Solde en Dollars US",
              amount: _balanceUsd,
              color: logoBlue, // Bleu logo
            ),
            const Divider(height: 24),
            
            // Solde Carnet
            _buildWalletItem(
              icon: Icons.book,
              title: "Solde Carnet",
              amount: _balanceCarnet,
              color: logoDarkBlue, // Bleu foncé logo
            ),
            const Divider(height: 24),
            
            // Reste Carnet
            _buildWalletItem(
              icon: Icons.book,
              title: "Reste Carnet",
              amount: _resteCarnet,
              color: logoDarkBlue, // Bleu foncé logo
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre section
            Text(
              "PORTEFEUILLES",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: logoDarkBlue.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Portefeuille en Francs Congolais
            _buildWalletItem(
              icon: Icons.account_balance_wallet,
              title: "Porte feuille en Fc",
              amount: _walletFc,
              color: logoGreen, // Vert logo
            ),
            const Divider(height: 24),
            
            // Portefeuille en Dollars
            _buildWalletItem(
              icon: Icons.attach_money,
              title: "Porte feuille en Dollars US",
              amount: _walletUsd,
              color: logoBlue, // Bleu logo
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletItem({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return Row(
      children: [
        // Icône
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        
        // Texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: logoDarkBlue.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        
        // Indicateur
        Icon(Icons.chevron_right, color: logoDarkBlue.withOpacity(0.3)),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre section
            Text(
              "INFORMATIONS PERSONNELLES",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: logoDarkBlue.withOpacity(0.7),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Nom complet
            _buildInfoItem(
              icon: Icons.person_outline,
              title: "Nom complet",
              value: _name,
            ),
            const Divider(height: 16),
            
            // Email
            _buildInfoItem(
              icon: Icons.email_outlined,
              title: "Adresse email",
              value: _email,
            ),
            const Divider(height: 16),
            
            // Téléphone
            _buildInfoItem(
              icon: Icons.phone_android,
              title: "Numéro de téléphone",
              value: _phone,
            ),
            const Divider(height: 16),
            
            // Rôle
            _buildInfoItem(
              icon: Icons.work_outline,
              title: "Rôle",
              value: _role,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        // Icône
        Icon(icon, color: logoBlue, size: 24), // Bleu logo pour les icônes
        const SizedBox(width: 16),
        
        // Texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: logoDarkBlue.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: logoDarkBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}