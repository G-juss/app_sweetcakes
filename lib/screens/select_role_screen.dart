import 'package:flutter/material.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  void _go(BuildContext context, String role) {
    Navigator.pushNamed(
      context,
      '/sign-in',
      arguments: role, // 'user' o 'admin'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SweetCakes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Cómo deseas ingresar?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _go(context, 'user'),
                child: const Text('Entrar como Usuario'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _go(context, 'admin'),
                child: const Text('Entrar como Administrador'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
