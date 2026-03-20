import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../login_success/login_success_screen.dart';
import '../../../network/api.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  SignFormState createState() => SignFormState();
}

class SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  final List<String?> errors = [];
  
  final ApiService _apiService = ApiService();

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final data = await _apiService.login(
        _emailController.text.trim(), 
        _passwordController.text.trim()
      );

      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        if (data['user'] != null) {
          await prefs.setString('user', data['user'].toString());
        }

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginSuccessScreen.routeName,
            (route) => false,
          );
        }
      } else {
        _showErrorSnackBar(data['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Champ Email avec fond blanc pour contraster
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc au lieu de gris
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: logoBlue.withOpacity(0.3)), // Bordure bleue légère
              boxShadow: [
                BoxShadow(
                  color: logoDarkBlue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 16, color: logoDarkBlue),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(
                  color: logoDarkBlue,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                hintText: "votre@email.com",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14, fontFamily: 'Poppins'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kEmailNullError);
                }
                if (emailValidatorRegExp.hasMatch(value)) {
                  removeError(error: kInvalidEmailError);
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: kEmailNullError);
                  return "";
                } else if (!emailValidatorRegExp.hasMatch(value)) {
                  addError(error: kInvalidEmailError);
                  return "";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Champ Mot de passe avec fond blanc
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc au lieu de gris
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: logoBlue.withOpacity(0.3)), // Bordure bleue légère
              boxShadow: [
                BoxShadow(
                  color: logoDarkBlue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              style: const TextStyle(fontSize: 16, color: logoDarkBlue),
              decoration: InputDecoration(
                labelText: "Mot de passe",
                labelStyle: const TextStyle(
                  color: logoDarkBlue,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
                hintText: "Entrez votre mot de passe",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14, fontFamily: 'Poppins'),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: logoBlue,
                    size: 20,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kPassNullError);
                }
                if (value.length >= 8) {
                  removeError(error: kShortPassError);
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: kPassNullError);
                  return "";
                } else if (value.length < 8) {
                  addError(error: kShortPassError);
                  return "";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          FormError(errors: errors),
          const SizedBox(height: 24),
          
          // Bouton de connexion avec effet d'ombre
          _isLoading
              ? Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: logoBlue.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                        color: logoBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
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
                          "Connexion...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: logoDarkBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logoDarkBlue,
                      foregroundColor: Colors.white,
                      elevation: 0, // Pas d'élévation car on utilise boxShadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    child: const Text("Se connecter"),
                  ),
                ),
        ],
      ),
    );
  }
}