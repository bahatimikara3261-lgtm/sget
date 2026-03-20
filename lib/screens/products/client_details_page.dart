import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/products/change_detail_modal.dart';
import 'package:shop_app/screens/products/formater.dart';
import 'package:shop_app/screens/products/modal_deposit.dart';

class ClientDetailsPage extends StatefulWidget {
  final Map<String, dynamic> clientData;

  const ClientDetailsPage({
    Key? key,
    required this.clientData,
  }) : super(key: key);

  @override
  ClientDetailsPageState createState() => ClientDetailsPageState();
}

class ClientDetailsPageState extends State<ClientDetailsPage> {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> transactions = [];
  Map<String, dynamic>? customerInfo;
  Map<String, dynamic>? epargne;
  num? total;
  var clientDataa;
  var change;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detailsCustomer();
    });
  }

  Future<void> _detailsCustomer() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientDataaa = await ApiService().searchClient(
        uuId: widget.clientData['customer']['uuid'].toString(),
      );

      if (mounted) {
        setState(() {
          transactions = (clientDataaa['mvtdepot'] as List?) ?? [];
          customerInfo =
              clientDataaa['customer'] as Map<String, dynamic>? ?? {};
          total = (clientDataaa['total'] as num?) ?? 0;
          epargne = clientDataaa['epargne'] as Map<String, dynamic>? ?? {};
          clientDataa = clientDataaa;
          change = epargne?['nbre_mois'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erreur: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background Jiwekee Akiba
      appBar: AppBar(
        title: const Text(
          'Détails Client',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: logoDarkBlue,
          ),
        ),
        backgroundColor: backgroundColor, // Même background que le body
        foregroundColor: logoDarkBlue, // Icônes bleu foncé
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(logoDarkBlue),
              ),
            )
          : customerInfo == null
              ? const Center(
                  child: Text(
                    'Chargement...',
                    style: TextStyle(color: logoDarkBlue),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carte infos client
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${customerInfo!['name']} ${customerInfo!['postname']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: logoDarkBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Montant par jour:',
                                '${Formater.formattage((customerInfo!['amount'] as num).toDouble())}${customerInfo!['currency']?['symbol']}',
                              ),
                              _buildInfoRow(
                                'Solde:',
                                '${Formater.formattage(total?.toDouble() ?? 0)}${customerInfo!['currency']?['symbol']}',
                              ),
                              _buildInfoRow(
                                'Nb Carnets:',
                                '${epargne?['nbre_mois']}',
                              ),
                              _buildInfoRow(
                                'Nb Carreaux:',
                                '${epargne?['nbre_jours']}',
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Boutons d'action
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ModalDeposit(
                                    uuId: customerInfo!['id'],
                                    currencyId: customerInfo!['currency_id'],
                                    onSuccess: _detailsCustomer,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: logoGreen, // Vert logo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: const Size(
                                    double.infinity, 40), // Hauteur fixe
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: const Text(
                                  'Effectuer un Dépôt',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (change == 0)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ChangeDetailModal(
                                      uuId: customerInfo!['id'],
                                      currencyId: customerInfo!['currency_id'],
                                      onSuccess: _detailsCustomer,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: logoBlue, // Bleu logo
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(
                                      double.infinity, 40), // Hauteur fixe
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: const Text(
                                    'Modifier le Montant',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section transactions
                      Row(
                        children: [
                          const Text(
                            'Historique des Transactions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: logoDarkBlue,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: logoBlue.withOpacity(
                                  0.1), // Bleu logo avec transparence
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: logoBlue.withOpacity(0.2)),
                            ),
                            child: Text(
                              '${transactions.length}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: logoDarkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      transactions.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 60,
                                    color: logoDarkBlue.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Aucune transaction',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: logoDarkBlue.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final isdeposit = transaction['typee'] == 1;
                                  final amount = (transaction['verser'] as num?)
                                          ?.toDouble() ??
                                      0.0;
                                  final currencySymbol = transaction['currency']
                                              ?['symbol']
                                          ?.toString() ??
                                      'Fc';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: isdeposit
                                                ? logoGreen.withOpacity(
                                                    0.1) // Vert logo avec transparence
                                                : Colors.red[100],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isdeposit
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            color: isdeposit
                                                ? logoGreen // Vert logo
                                                : Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          isdeposit ? 'Dépôt' : 'Retrait',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: logoDarkBlue,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Par: ${transaction['user']?['name'] ?? 'Non spécifié'}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: logoDarkBlue
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            Text(
                                              Formater.formatdate(
                                                  transaction['created_at']),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: logoDarkBlue
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          '${Formater.formattage(amount)}$currencySymbol',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isdeposit
                                                ? logoGreen // Vert logo
                                                : Colors.red[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color:
                  logoDarkBlue.withOpacity(0.6), // Bleu foncé avec transparence
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: logoDarkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
