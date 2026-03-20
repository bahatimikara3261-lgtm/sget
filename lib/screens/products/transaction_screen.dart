import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/products/formater.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  List<dynamic> _transactions = [];
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _rapport;
  late String _date;
  bool _isLoading = true;
  String? _errorMessage;
  
  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getdaytransaction(); // Appel DIO

      if (mounted) {
        setState(() {
          _userInfo = data['users'];
          _transactions = data['depot'] ?? [];
          _rapport = data['rapport'];
          _date = data['date'] ?? 'Date non disponible';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Méthode pour rafraîchir
  Future<void> _refreshData() async {
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const _LoadingState();
    }

    if (_errorMessage != null) {
      return _ErrorState(
        errorMessage: _errorMessage!,
        onRetry: _refreshData,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête utilisateur
          _buildUserHeader(),
          const SizedBox(height: 16),
          
          // Liste des transactions
          _buildTransactionsList(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: logoBlue.withOpacity(0.1), // Bleu logo avec transparence
              child: Icon(Icons.person, color: logoBlue), // Bleu logo
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_userInfo?['name'] ?? 'Utilisateur'}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: logoDarkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return const _EmptyState();
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          final isDeposit = transaction['typee'] == 1;
          
          return _TransactionItem(
            transaction: transaction,
            isDeposit: isDeposit,
          );
        },
      ),
    );
  }
}

// État de chargement
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  // Couleurs du logo Jiwekee Akiba
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(logoDarkBlue),
          ),
          SizedBox(height: 16),
          Text(
            'Chargement des transactions...',
            style: TextStyle(color: logoDarkBlue),
          ),
        ],
      ),
    );
  }
}

// État d'erreur
class _ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  const _ErrorState({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: logoBlue, size: 50),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: logoDarkBlue),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
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
}

// État vide
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  // Couleurs du logo Jiwekee Akiba
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 60, color: logoDarkBlue.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction trouvée',
            style: TextStyle(fontSize: 16, color: logoDarkBlue),
          ),
          const SizedBox(height: 8),
          Text(
            'Vos transactions apparaîtront ici',
            style: TextStyle(fontSize: 14, color: logoDarkBlue.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

// Item de transaction
class _TransactionItem extends StatelessWidget {
  final dynamic transaction;
  final bool isDeposit;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  const _TransactionItem({
    required this.transaction,
    required this.isDeposit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isDeposit ? logoGreen : Colors.red, // Vert logo pour dépôts
              width: 4,
            ),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isDeposit ? logoGreen.withOpacity(0.1) : Colors.red[100],
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isDeposit ? logoGreen : Colors.red, // Vert logo pour dépôts
            ),
          ),
          title: Text(
            isDeposit ? 'Dépôt' : 'Retrait',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: logoDarkBlue,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${transaction['customer']['name']} ${transaction['customer']['postname']}',
                style: TextStyle(
                  fontSize: 14,
                  color: logoDarkBlue.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                Formater.formatdate(transaction['created_at']),
                style: TextStyle(
                  fontSize: 12,
                  color: logoDarkBlue.withOpacity(0.6),
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction['verser']}${transaction['currency']['symbol']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDeposit ? logoGreen : Colors.red[700], // Vert logo pour dépôts
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction['currency']['name'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: logoDarkBlue.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}