import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/products/client_details_page.dart';

class DepositForm extends StatefulWidget {
  const DepositForm({Key? key}) : super(key: key);

  @override
  DepositFormState createState() => DepositFormState();
}

class DepositFormState extends State<DepositForm> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  Future<void> _searchClient() async {
    if (!_formKey.currentState!.validate()) return;

    // Cacher le clavier
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientData = await _apiService.searchClient( // Appel DIO
        uuId: _clientIdController.text.trim(),
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientDetailsPage(clientData: clientData),
          ),
        );
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

  @override
  void dispose() {
    _clientIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête visuel
          _buildHeader(),
          const SizedBox(height: 32),
          
          // Formulaire
          _buildSearchForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icône et titre
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: logoGreen.withOpacity(0.1), // Vert logo avec transparence
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: logoGreen, // Vert logo
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Rechercher un Client",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: logoDarkBlue, // Bleu foncé logo
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        
        // Info supplémentaire
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: logoBlue.withOpacity(0.1), // Bleu logo avec transparence
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: logoBlue.withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: logoBlue), // Bleu logo
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Le numéro se trouve sur le carnet du client",
                  style: TextStyle(
                    fontSize: 14,
                    color: logoDarkBlue, // Bleu foncé logo
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Champ de recherche
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: logoDarkBlue.withOpacity(0.1), // Ombre bleu foncé
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: _clientIdController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w500,
                color: logoDarkBlue,
              ),
              decoration: InputDecoration(
                labelText: 'Numéro du Carnet Client',
                labelStyle: TextStyle(
                  color: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec transparence
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Ex: 123456',
                hintStyle: TextStyle(color: logoDarkBlue.withOpacity(0.4)),
                prefixIcon: const Icon(Icons.numbers, color: logoGreen), // Vert logo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: logoGreen, width: 2), // Vert logo pour focus
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le numéro du carnet';
                }
                
                return null;
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Bouton de recherche
          _buildSearchButton(),
          
          // Message d'erreur
          if (_errorMessage != null) _buildErrorWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: _isLoading
          ? ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoGreen.withOpacity(0.7), // Vert logo avec opacité
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Recherche en cours...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: _searchClient,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoGreen, // Vert logo
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: logoGreen.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Rechercher le Client',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}