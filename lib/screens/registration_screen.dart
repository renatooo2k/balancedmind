import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Função preparada para a chamada da API de Cadastro
  Future<void> _handleRegistration() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Verifica se as senhas coincidem
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // --- PONTO DE INTEGRAÇÃO COM BACKEND: CADASTRO ---
    // Aqui você faria a chamada HTTP (POST) para sua API de Cadastro.
    // O body JSON conteria:
    // {
    //   "nome": _nameController.text,
    //   "email": _emailController.text,
    //   "password": _passwordController.text
    // }
    
    // Simulação de espera de API
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso! Pode fazer o login.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Nova Conta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Bem-vindo(a) ao BalancedMind',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Preencha os dados para começar.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um email válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                   validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                   validator: (value) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleRegistration,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        child: const Text('Registrar', style: TextStyle(fontSize: 18)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}