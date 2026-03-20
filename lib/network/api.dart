import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = "http://192.168.1.159/jiwekeeakiba/public_html/api/v1";

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    // Intercepteur pour l'authentification automatique
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ajouter le token automatiquement à chaque requête
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = 'application/json';
        
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Gestion centralisée des erreurs d'authentification
        if (error.response?.statusCode == 401) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
        }
        return handler.next(error);
      },
    ));
  }

  // Getter pour la baseUrl (utilisé dans profile.dart)
  String get baseUrl => "https://jiwekeeakiba.com";

  // MÉTHODE POUR MODIFIER LE MOT DE PASSE
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/users/updatepassword',
        data: {
          'oldpassword': currentPassword,
          'newpassword': newPassword,
          'confirmpassword': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data;
        throw Exception(errorData['message'] ?? 'Erreur de modification du mot de passe');
      }
      throw Exception('Erreur réseau: ${e.message}');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // === MÉTHODES EXISTANTES ===
  
  Future<String?> user() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur connexion: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> searchClient({required String uuId}) async {
    try {
      final response = await _dio.post(
        '/customers/checkenteruuid',
        data: {'uuid': uuId},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Client non trouvé');
      }
      throw Exception('Erreur recherche: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> createClient({
    required String uuId,
    required String name,
    required String postname,
    required String email,
    required String phone,
    required String profession,
    required String adresse,
    required String amount,
    required String birthdayplace,
    required String birthdaydate,
    required int currency,
    required int axe,
    required int sexe,
  }) async {
    try {
      final response = await _dio.post(
        '/customers/create',
        data: {
          'uuid': uuId,
          'name': name,
          'postname': postname,
          'tel': phone,
          'email': email,
          'profession': profession,
          'address': adresse,
          'axe': axe,
          'currency': currency,
          'amount': amount,
          'gender': sexe,
          'birthday_place': birthdayplace,
          'birthday_date': birthdaydate,
        },
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Client non trouvé');
      }
      throw Exception('Erreur création: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getbalance() async {
    try {
      final response = await _dio.get('/balance-user');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur solde: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getdaytransaction() async {
    try {
      final response = await _dio.get('/transaction-user');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur transactions: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> fetchDataAxe() async {
    try {
      final response = await _dio.get('/customers/create/check');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur données axe: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur POST: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erreur GET: ${e.message}');
    }
  }
}