import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/products/client_details_page.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({Key? key}) : super(key: key);

  @override
  CreateFormState createState() => CreateFormState();
}

class CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _postnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _adresseController = TextEditingController();
  final _amountController = TextEditingController();
  final _birthdayplaceController = TextEditingController();
  final _birthdaydateController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _selectedDate;

  List<dynamic> _itemsaxe = [];
  List<dynamic> _itemscurrency = [];
  List<dynamic> _itemssexe = [];
  dynamic _selectedItemaxe;
  dynamic _selectedItemCurrency;
  dynamic _selectedItemsexe;

  final ApiService _apiService = ApiService(); // Instance DIO

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  @override
  void initState() {
    super.initState();
    _fetchDataAxe();
  }

  Future<void> _fetchDataAxe() async {
    try {
      final clientDataAxe = await _apiService.fetchDataAxe(); // Appel DIO

      if (mounted) {
        setState(() {
          _itemsaxe = clientDataAxe['axe'] ?? [];
          _itemscurrency = clientDataAxe['currency'] ?? [];
          _itemssexe = clientDataAxe['sexe'] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: logoBlue, // Bleu logo
              onPrimary: Colors.white,
              onSurface: logoDarkBlue, // Bleu foncé logo
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: logoBlue, // Bleu logo
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdaydateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _createClient() async {
    if (!_formKey.currentState!.validate()) return;

    // Cacher le clavier
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final clientData = await _apiService.createClient(
        // Appel DIO
        uuId: _clientIdController.text,
        name: _nameController.text,
        postname: _postnameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        profession: _professionController.text,
        adresse: _adresseController.text,
        amount: _amountController.text,
        birthdayplace: _birthdayplaceController.text,
        birthdaydate: _birthdaydateController.text,
        currency: _selectedItemCurrency,
        sexe: _selectedItemsexe,
        axe: _selectedItemaxe,
      );

      if (mounted) {
        Navigator.pushReplacement(
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
    _nameController.dispose();
    _postnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _adresseController.dispose();
    _amountController.dispose();
    _birthdayplaceController.dispose();
    _birthdaydateController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16, color: logoDarkBlue),
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? ' *' : ''),
          labelStyle: TextStyle(
            color: logoDarkBlue.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
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
            borderSide: BorderSide(color: logoBlue, width: 2), // Bleu logo pour focus
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator ?? (isRequired ? _defaultValidator : null),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

  Widget _buildDropdown({
    required String labelText,
    required List<dynamic> items,
    required dynamic value,
    required Function(dynamic) onChanged,
    required String displayKey,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<dynamic>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText + (isRequired ? ' *' : ''),
          labelStyle: TextStyle(
            color: logoDarkBlue.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoBlue, width: 2), // Bleu logo pour focus
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map<DropdownMenuItem<dynamic>>((item) {
          return DropdownMenuItem<dynamic>(
            value: item['id'],
            child: Text(
              item[displayKey] ?? 'Non spécifié',
              style: TextStyle(fontSize: 16, color: logoDarkBlue),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: isRequired
            ? (value) {
                if (value == null) {
                  return 'Veuillez sélectionner une option';
                }
                return null;
              }
            : null,
        style: TextStyle(fontSize: 16, color: logoDarkBlue),
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Informations personnelles
          _buildSectionTitle('Informations Personnelles'),
          _buildTextField(
            controller: _clientIdController,
            labelText: 'Numéro Carnet',
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          _buildTextField(
            controller: _nameController,
            labelText: 'Nom du client',
            isRequired: true,
          ),
          _buildTextField(
            controller: _postnameController,
            labelText: 'Postnom du client',
            isRequired: true,
          ),
          _buildTextField(
            controller: _emailController,
            labelText: 'Email du client',
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            controller: _phoneController,
            labelText: 'Téléphone du client',
            keyboardType: TextInputType.phone,
          ),

          // Informations professionnelles
          _buildSectionTitle('Informations Professionnelles'),
          _buildTextField(
            controller: _professionController,
            labelText: 'Profession du client',
          ),
          _buildTextField(
            controller: _adresseController,
            labelText: 'Adresse du client',
            isRequired: true,
          ),

          // Informations de naissance
          _buildSectionTitle('Informations de Naissance'),
          _buildTextField(
            controller: _birthdayplaceController,
            labelText: 'Lieu de naissance',
            isRequired: true,
          ),
          _buildDateField(),

          // Sélections
          _buildSectionTitle('Paramètres'),
          _buildDropdown(
            labelText: 'Sexe',
            items: _itemssexe,
            value: _selectedItemsexe,
            onChanged: (value) => setState(() => _selectedItemsexe = value),
            displayKey: 'description',
            isRequired: true,
          ),
          _buildDropdown(
            labelText: 'Axe',
            items: _itemsaxe,
            value: _selectedItemaxe,
            onChanged: (value) => setState(() => _selectedItemaxe = value),
            displayKey: 'name',
            isRequired: true,
          ),
          _buildDropdown(
            labelText: 'Devise',
            items: _itemscurrency,
            value: _selectedItemCurrency,
            onChanged: (value) => setState(() => _selectedItemCurrency = value),
            displayKey: 'name',
            isRequired: true,
          ),

          // Montant
          _buildTextField(
            controller: _amountController,
            labelText: 'Montant initial',
            keyboardType: TextInputType.number,
            isRequired: true,
          ),

          const SizedBox(height: 24),

          // Bouton de soumission
          _buildSubmitButton(),
          const SizedBox(width: 20),
          // Message d'erreur
          if (_errorMessage != null) _buildErrorWidget(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: logoDarkBlue, // Bleu foncé logo
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _birthdaydateController,
        style: TextStyle(color: logoDarkBlue),
        decoration: InputDecoration(
          labelText: 'Date de naissance *',
          labelStyle: TextStyle(
            color: logoDarkBlue.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoBlue, width: 2), // Bleu logo pour focus
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: logoBlue), // Bleu logo
            onPressed: () => _selectDate(context),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez sélectionner une date';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: _isLoading
          ? ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoDarkBlue.withOpacity(0.7), // Bleu foncé avec opacité
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                    'Création en cours...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: _createClient,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoDarkBlue, // Bleu foncé logo
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Créer le Client',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
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
              style: TextStyle(color: Colors.red[700], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}