import 'package:flutter/material.dart';
import 'package:shop_app/screens/products/transaction_screen.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  static String routeName = "/transaction_screen";

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
          "Historique des Transactions",
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
            // En-tête informatif
            _TransactionHeader(),
            // Contenu des transactions
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TransactionScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// En-tête informatif pour les transactions
class _TransactionHeader extends StatelessWidget {
  const _TransactionHeader();

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: logoBlue.withOpacity(0.1), // Bleu logo avec transparence
        border: Border(
          bottom: BorderSide(color: logoDarkBlue.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vos transactions récentes",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec transparence
            ),
          ),
        ],
      ),
    );
  }
}