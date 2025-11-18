import 'package:flutter/material.dart';
import 'main_screen.dart'; 
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Prepara o código para a chamada da API de autenticação.
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // --- PONTO DE INTEGRAÇÃO COM BACKEND: LOGIN ---
    // Aqui você faria a chamada HTTP (POST) para sua API de Login.
    
    // Simulação de espera de API
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
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
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                    ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text('Criar uma conta (Cadastro)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}