import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Future<Map<String, dynamic>> _futureUserData;
  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  void initState() {
    super.initState();
    _futureUserData = _apiService.getbalance(); // Utilisation DIO
  }

  // Méthode pour rafraîchir les données
  Future<void> _refreshData() async {
    setState(() {
      _futureUserData = _apiService.getbalance();
    });
  }

  Widget _buildTableRow(String title, String value, {bool isHeader = false, bool isAmount = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? logoBlue.withOpacity(0.1) : Colors.white,
        border: Border(
          bottom: BorderSide(color: logoDarkBlue.withOpacity(0.1), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isHeader ? logoDarkBlue : logoDarkBlue.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                  color: isAmount ? _getAmountColor(title, value) : logoDarkBlue.withOpacity(0.8),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAmountColor(String title, String value) {
    if (title.contains('Solde') || title.contains('Commission')) {
      return logoGreen; // Vert logo pour soldes positifs
    } else if (title.contains('Dette')) {
      return Colors.red[700]!; // Rouge pour dettes
    } else if (title.contains('Dépôt')) {
      return logoBlue; // Bleu logo pour dépôts
    } else if (title.contains('Rétrait')) {
      return Colors.orange[700]!; // Orange pour retraits
    }
    return logoDarkBlue; // Bleu foncé par défaut
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [logoDarkBlue, logoBlue], // Dégradé bleu foncé → bleu logo
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _futureUserData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: logoBlue, size: 50),
                      const SizedBox(height: 10),
                      Text(
                        'Erreur: ${snapshot.error}',
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
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
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

          final data = snapshot.data!;
          final user = data['users'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(), // Pour RefreshIndicator
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Card(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rapport du: ${data['date']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          user['email'],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Section Soldes
                _buildSection('SOLDES', [
                  _buildTableRow("Solde Fc", "${data['balancecdf']} Fc", isAmount: true),
                  _buildTableRow("Solde \$", "${data['balanceusd']} \$", isAmount: true),
                  _buildTableRow("Solde Carnet", "${data['balancecarnet']} Fc", isAmount: true),
                  _buildTableRow("Reste Carnet", "${data['restecarnet']}", isAmount: true),
                ]),

                // Section Dettes
                _buildSection('DETTES', [
                  _buildTableRow("Dette Fc", "${data['dettecdf']} Fc", isAmount: true),
                  _buildTableRow("Dette \$", "${data['detteusd']} \$", isAmount: true),
                ]),

                // Section Transactions
                _buildSection('TRANSACTIONS', [
                  _buildTableRow("Dépôt Fc", "${data['depositcdf']} Fc", isAmount: true),
                  _buildTableRow("Dépôt \$", "${data['depositusd']} \$", isAmount: true),
                  _buildTableRow("Rétrait Fc", "${data['withdrawalcdf']} Fc", isAmount: true),
                  _buildTableRow("Rétrait \$", "${data['withdrawalusd']} \$", isAmount: true),
                ]),

                // Section Commissions
                _buildSection('COMMISSIONS', [
                  _buildTableRow("Commission Fc", "${data['salary_cdf']} Fc", isAmount: true),
                  _buildTableRow("Commission \$", "${data['salary_usd']} \$", isAmount: true),
                ]),

                // Section Informations
                _buildSection('INFORMATIONS', [
                  _buildTableRow("Téléphone", user['tel'] ?? 'Non renseigné'),
                  _buildTableRow("Axe", "${user['axe']['name']} (${user['axe']['quarter']})"),
                  _buildTableRow("Rôle", user['roles'][0]['name']),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}