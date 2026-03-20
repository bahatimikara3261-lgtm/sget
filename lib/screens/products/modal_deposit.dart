import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

class ModalDeposit extends StatefulWidget {
  final int uuId;
  final int currencyId;
  final Function() onSuccess;

  const ModalDeposit({
    Key? key,
    required this.uuId,
    required this.currencyId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _ModalDepositState createState() => _ModalDepositState();
}

class _ModalDepositState extends State<ModalDeposit> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Cacher le clavier
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.postData( // Appel DIO
        '/customers/deposit',
        {
          'customer_id': widget.uuId.toString(),
          'currency_id': widget.currencyId.toString(),
          'amount': double.parse(_amountController.text),
        },
      );

      if (response['success'] == true) {
        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'Succès',
            desc: 'Dépôt effectué avec succès',
            btnOkText: 'OK',
            btnOkColor: logoGreen, // Vert logo
            btnOkOnPress: () {
              widget.onSuccess();
              Navigator.pop(context);
            },
          ).show();
        }
      } else {
        if (mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Erreur',
            desc: response['message'] ?? 'Erreur inconnue',
            btnOkText: 'OK',
          ).show();
        }
      }
    } catch (e) {
      if (mounted) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Erreur',
          desc: 'Erreur de connexion: ${e.toString().replaceFirst('Exception: ', '')}',
          btnOkText: 'OK',
        ).show();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: logoGreen.withOpacity(0.1), // Vert logo avec transparence
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: logoGreen, // Vert logo
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Effectuer un Dépôt',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: logoDarkBlue, // Bleu foncé logo
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Entrez le montant à déposer pour ce client',
                style: TextStyle(
                  fontSize: 14,
                  color: logoDarkBlue.withOpacity(0.6), // Bleu foncé avec transparence
                ),
              ),
              
              const SizedBox(height: 24),

              // Champ de saisie
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w500,
                  color: logoDarkBlue,
                ),
                decoration: InputDecoration(
                  labelText: 'Montant du Dépôt',
                  labelStyle: TextStyle(
                    color: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec transparence
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Ex: 10000',
                  hintStyle: TextStyle(color: logoDarkBlue.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.attach_money, color: logoGreen), // Vert logo
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: logoGreen, width: 2), // Vert logo pour focus
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Montant invalide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Le montant doit être positif';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec transparence
                        side: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: logoGreen, // Vert logo
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Déposer',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}