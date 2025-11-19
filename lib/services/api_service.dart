import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user_session.dart';

class ApiService {
  static const String baseUrl = 'https://balancedmind.lat/api/v1';

  // --- MÉTODO POST (Salvar dados) ---
  static Future<http.Response> postAuthenticated(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    // 1. Tenta fazer a requisição normal
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserSession.idToken}',
      },
      body: jsonEncode(body),
    );

    // 2. Se der erro 401 (Não autorizado), tenta renovar o token
    if (response.statusCode == 401) {
      print("Token expirado (POST)! Tentando renovar...");
      final success = await _refreshToken();

      if (success) {
        print("Token renovado! Refazendo POST...");
        // 3. Se renovou, tenta a requisição de novo
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserSession.idToken}',
          },
          body: jsonEncode(body),
        );
      }
    }

    return response;
  }

  // --- MÉTODO GET (Buscar dados/histórico) ---
  static Future<http.Response> getAuthenticated(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    // 1. Tenta fazer a requisição normal
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserSession.idToken}',
      },
    );

    // 2. Se der erro 401, tenta renovar
    if (response.statusCode == 401) {
      print("Token expirado (GET)! Tentando renovar...");
      final success = await _refreshToken();

      if (success) {
        print("Token renovado! Refazendo GET...");
        // 3. Se renovou, tenta de novo
        response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${UserSession.idToken}',
          },
        );
      }
    }

    return response;
  }

  static Future<bool> _refreshToken() async {
    if (UserSession.refreshToken == null) return false;

    try {
      final url = Uri.parse('$baseUrl/auth/refresh');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': UserSession.refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        UserSession.idToken = data['idToken'];
        if (data.containsKey('refreshToken')) {
           UserSession.refreshToken = data['refreshToken'];
        }
        return true;
      } else {
        print("Falha ao renovar token: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro no refresh: $e");
      return false;
    }
  }
}