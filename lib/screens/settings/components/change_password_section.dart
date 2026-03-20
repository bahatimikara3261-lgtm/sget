import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

class ChangePasswordSection extends StatefulWidget {
  const ChangePasswordSection({super.key});

  @override
  State<ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends State<ChangePasswordSection> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Cacher le clavier
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await _apiService.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _confirmPasswordController.text,
      );

      if (response['success'] == true) {
        setState(() {
          _successMessage = response['message'] ?? 'Mot de passe modifié avec succès';
        });
        
        // Vider les champs après succès
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        
        // Cacher le message après 3 secondes
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _successMessage = null;
            });
          }
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Erreur lors du changement de mot de passe';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la section
            Row(
              children: [
                Icon(Icons.lock, color: logoDarkBlue, size: 24), // Bleu foncé logo
                const SizedBox(width: 12),
                Text(
                  "Changer le mot de passe",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: logoDarkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Mettez à jour votre mot de passe pour sécuriser votre compte",
              style: TextStyle(
                fontSize: 14,
                color: logoDarkBlue.withOpacity(0.6), // Bleu foncé avec transparence
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Formulaire
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mot de passe actuel
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: 'Mot de passe actuel',
                    obscureText: _obscureCurrentPassword,
                    onToggleVisibility: () => setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nouveau mot de passe
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'Nouveau mot de passe',
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () => setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    }),
                    isNew: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirmation nouveau mot de passe
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirmer le nouveau mot de passe',
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () => setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }),
                    isNew: true,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton de modification
                  _buildSubmitButton(),
                  
                  // Messages
                  if (_errorMessage != null) _buildErrorWidget(),
                  if (_successMessage != null) _buildSuccessWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    bool isNew = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: logoDarkBlue),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: logoDarkBlue.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: logoDarkBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: logoBlue, width: 2), // Bleu logo pour focus
        ),
        prefixIcon: Icon(Icons.lock, color: logoDarkBlue.withOpacity(0.6)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: logoBlue, // Bleu logo pour l'icône visibilité
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est obligatoire';
        }
        if (isNew && value.length < 6) {
          return 'Le mot de passe doit contenir au moins 6 caractères';
        }
        if (isNew && _newPasswordController.text.isNotEmpty && 
            _confirmPasswordController.text.isNotEmpty &&
            _newPasswordController.text != _confirmPasswordController.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
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
                    'Modification en cours...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: logoDarkBlue, // Bleu foncé logo
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Changer le mot de passe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 20),
          const SizedBox(width: 8),
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

  Widget _buildSuccessWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: logoGreen.withOpacity(0.1), // Vert logo avec transparence
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: logoGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: logoGreen, size: 20), // Vert logo
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _successMessage!,
              style: TextStyle(color: logoDarkBlue, fontSize: 14), // Bleu foncé pour le texte
            ),
          ),
        ],
      ),
    );
  }
}