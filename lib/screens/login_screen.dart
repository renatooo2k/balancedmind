import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_screen.dart';
import 'registration_screen.dart';
import '../user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha e-mail e senha.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('https://balancedmind.lat/api/v1/auth/login');
      final Map<String, String> bodyData = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text
      };

      print("----- TENTANDO LOGIN -----");
      print("curl --location '${url.toString()}' \\");
      print("--header 'Content-Type: application/json' \\");
      print("--data-raw '${jsonEncode(bodyData)}'");
      print("--------------------------");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPOSTA: ${response.body}");

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);
        UserSession.idToken = data['idToken'];
        UserSession.refreshToken = data['refreshToken'];
        print("Login realizado! Token salvo.");

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        String errorMsg = "Falha no login.";
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ?? errorData['error'] ?? response.body;
        } catch (_) {
          errorMsg = response.body;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: $errorMsg'), 
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print("ERRO EXCEPTION: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro de conexão. Verifique sua internet.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.psychology_alt, size: 80, color: Color(0xFF673AB7)),
                const SizedBox(height: 16),
                Text(
                  'BalancedMind', 
                  textAlign: TextAlign.center, 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF1F2937)
                  )
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email', 
                    prefixIcon: const Icon(Icons.email), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                ),
                const SizedBox(height: 16),
   
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha', 
                    prefixIcon: const Icon(Icons.lock), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                ),
                const SizedBox(height: 30),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 55)),
                        child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                      ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RegistrationScreen())
                    );
                  },
                  child: const Text('Criar uma conta (Cadastro)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}