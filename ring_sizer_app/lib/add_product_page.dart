import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  final int sellerId; // On reçoit l'ID du vendeur connecté

  const AddProductPage({super.key, required this.sellerId});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _titleController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();

  // Par défaut 18k (doit correspondre à une valeur de la liste ci-dessous)
  String _purity = '18k';

  Future<void> submitProduct() async {
    // ⚠️ Remplace 10.0.2.2 par ton IP locale si tu es sur un vrai téléphone
    final url = Uri.parse("http://10.0.2.2:8000/api/products");

    // Validation basique pour éviter d'envoyer du vide
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir le nom et le prix"), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": _titleController.text,
          "weight_g": double.tryParse(_weightController.text) ?? 0.0,
          "price_fixed": double.tryParse(_priceController.text) ?? 0.0,
          "purity": _purity,
          "seller_id": widget.sellerId, // L'ID du vendeur connecté
          "images": [] // <--- CRUCIAL : On envoie une liste vide pour éviter les erreurs JSON null
        }),
      );

      if (response.statusCode == 201) {
        // Succès : on ferme la page et on renvoie "true" pour dire de recharger la liste
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Produit mis en vente avec succès !"), backgroundColor: Colors.green),
        );
      } else {
        print("ERREUR DU SERVEUR : ${response.body}");
        throw Exception("Le serveur a refusé l'ajout (Code ${response.statusCode})");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Vendre un bijou"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white
      ),
      body: SingleChildScrollView( // Ajout du scroll pour les petits écrans
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Nom du bijou (ex: Bague Mariage)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: "Poids en grammes (ex: 5.5)"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Prix (MAD)"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),

            // Sélecteur de Carats
            DropdownButtonFormField<String>(
              value: _purity,
              decoration: const InputDecoration(labelText: "Pureté de l'or"),
              items: const [
                DropdownMenuItem(value: '18k', child: Text("Or 18k")),
                DropdownMenuItem(value: '22k', child: Text("Or 22k")), // Doit matcher l'enum MySQL
                DropdownMenuItem(value: '24k', child: Text("Or 24k")),
              ],
              onChanged: (val) => setState(() => _purity = val!),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitProduct,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 15)
                ),
                child: const Text("METTRE EN VENTE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}