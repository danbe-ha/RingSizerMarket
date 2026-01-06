import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Pour aller vers l'accueil

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour récupérer le texte
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool isLogin = true; // Pour alterner entre Connexion et Inscription
  String selectedRole = 'user'; // Par défaut : Client

  Future<void> submit() async {
    // ⚠️ METS TON ADRESSE IP ICI (10.0.2.2 pour émulateur, 192.168... pour vrai tél)
    final baseUrl = "http://10.0.2.2:8000/api";
    final url = Uri.parse(isLogin ? "$baseUrl/login" : "$baseUrl/register");

    Map<String, dynamic> data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    if (!isLogin) {
      data["name"] = _nameController.text;
      data["role"] = selectedRole;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final body = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogin) {
          // Si connexion réussie, on va à l'accueil avec le RÔLE
          String role = body['role'];
          int userId = body['user']['id'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RingSizerHomePage(userRole: role, userId: userId)),
          );
        } else {
          // Si inscription réussie
          setState(() => isLogin = true); // On bascule sur l'écran de connexion
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Compte créé ! Connectez-vous.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? "Erreur"), backgroundColor: Colors.red));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur serveur: $e"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber.shade800, Colors.amber.shade200], begin: Alignment.topLeft, end: Alignment.bottomRight)
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isLogin ? "Connexion" : "Inscription", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  if (!isLogin) ...[
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nom complet", prefixIcon: Icon(Icons.person))),
                    const SizedBox(height: 10),
                    // Choix du rôle
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text("Je suis Client (Acheteur)")),
                        DropdownMenuItem(value: 'seller', child: Text("Je suis Vendeur (Bijoutier)")),
                      ],
                      onChanged: (val) => setState(() => selectedRole = val!),
                    ),
                    const SizedBox(height: 10),
                  ],

                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email))),
                  const SizedBox(height: 10),
                  TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Mot de passe", prefixIcon: Icon(Icons.lock))),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12)),
                    child: Text(isLogin ? "SE CONNECTER" : "S'INSCRIRE"),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(isLogin ? "Pas de compte ? Créer un compte" : "Déjà un compte ? Se connecter"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}