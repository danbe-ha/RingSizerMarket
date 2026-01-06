import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ring_sizer_page.dart'; // Assure-toi que ce fichier existe
import 'add_product_page.dart'; // Assure-toi que ce fichier existe
import 'gold_chart_page.dart'; // Assure-toi que ce fichier existe
import 'login_page.dart'; // <--- IMPORT IMPORTANT POUR LA PAGE DE LOGIN
import 'orders_page.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Ring Sizer Market',
    debugShowCheckedModeBanner: false,
    // ON DÉMARRE SUR LA PAGE DE LOGIN MAINTENANT
    home: LoginPage(),
  ));
}

class RingSizerHomePage extends StatefulWidget {
  // Ces variables permettent de savoir QUI est connecté
  final String userRole; // 'seller' ou 'user'
  final int userId;      // L'ID unique de l'utilisateur

  // Le constructeur oblige à fournir ces infos
  const RingSizerHomePage({
    super.key,
    required this.userRole,
    required this.userId
  });

  @override
  State<RingSizerHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<RingSizerHomePage> {
  List products = [];
  Map<String, dynamic>? goldPrice;
  bool isLoading = true;

  // ⚠️ ATTENTION : Utilise 10.0.2.2 pour l'émulateur
  final String productUrl = "http://10.0.2.2:8000/api/products";
  final String goldUrl = "http://10.0.2.2:8000/api/gold-price";

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final prodResponse = await http.get(Uri.parse(productUrl));
      final goldResponse = await http.get(Uri.parse(goldUrl));

      if (mounted) {
        setState(() {
          if (prodResponse.statusCode == 200) {
            products = json.decode(prodResponse.body);
          }
          if (goldResponse.statusCode == 200) {
            goldPrice = json.decode(goldResponse.body);
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fonction pour se déconnecter
  void logout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.userRole == 'seller' ? "Espace Vendeur" : "Espace Client"),
              accountEmail: Text("ID: ${widget.userId}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.amber),
              ),
              decoration: BoxDecoration(color: widget.userRole == 'seller' ? Colors.black : Colors.amber),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: Text(widget.userRole == 'seller' ? "Mes Ventes" : "Mes Commandes"),
              onTap: () {
                Navigator.pop(context); // Ferme le menu
                // Va vers la page Historique (import orders_page.dart !)
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    OrdersPage(userRole: widget.userRole, userId: widget.userId)
                ));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text("Se déconnecter"),
              onTap: () {
                // Fonction logout qui existe déjà dans ton code
                logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Ring Sizer Market 💍"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // BOUTON SYNC (PRIX OR)
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: "Mettre à jour le prix",
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Mise à jour du cours... 🌍")),
              );
              final url = Uri.parse("http://10.0.2.2:8000/api/gold-price/refresh");
              try {
                await http.post(url); // On ignore la réponse pour simplifier, on recharge juste
                await fetchAllData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Prix mis à jour !"), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Erreur connexion"), backgroundColor: Colors.red),
                );
              }
            },
          ),
          // BOUTON DÉCONNEXION (SORTIE)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: "Se déconnecter",
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. BANDEAU PRIX OR
          if (goldPrice != null)
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GoldChartPage()));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber[800]!, Colors.amber[400]!]),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.show_chart, color: Colors.white),
                        SizedBox(width: 8),
                        Text("COURS DE L'OR >", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("18k : ${goldPrice!['price_18k']} MAD", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("24k : ${goldPrice!['price_24k']} MAD", style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // 2. BOUTON MESURE (Accessible à tous)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: ElevatedButton.icon(
              icon: const Icon(Icons.straighten),
              label: const Text("📏 Mesurer ma taille de bague"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RingSizerPage()));
              },
            ),
          ),

          // 3. LISTE DES PRODUITS
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(child: Text("Aucun produit disponible"))
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.amber[100],
                            child: Text(item['purity'] ?? 'Or', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(item['title'] ?? 'Bague', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text("Poids : ${item['weight_g']}g", style: TextStyle(color: Colors.grey[600])),
                          trailing: Text(
                            "${item['price_fixed']} MAD",
                            style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),

                        // --- CONDITION : BOUTON COMMANDER (SEULEMENT POUR LES CLIENTS) ---
                        if (widget.userRole == 'user') ...[
                          const Divider(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text("COMMANDER CET ARTICLE"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              onPressed: () async {
                                final url = Uri.parse("http://10.0.2.2:8000/api/orders");
                                try {
                                  final response = await http.post(
                                    url,
                                    headers: {"Content-Type": "application/json"},
                                    body: json.encode({
                                      "product_id": item['id'],
                                      "price": item['price_fixed'],
                                      "user_id": widget.userId, // On envoie le VRAI ID du client connecté
                                      "seller_id": 1 // Pour l'instant on laisse 1 ou on le récupère du produit si disponible
                                    }),
                                  );

                                  if (response.statusCode == 201 || response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("✅ Commande envoyée !"), backgroundColor: Colors.green),
                                    );
                                  } else {
                                    throw Exception("Erreur serveur ${response.statusCode}");
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
                                  );
                                }
                              },
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // --- CONDITION : BOUTON VENDRE (SEULEMENT POUR LES VENDEURS) ---
      floatingActionButton: widget.userRole == 'seller'
          ? FloatingActionButton.extended(
        onPressed: () async {
          // ON PASSE L'ID DU VENDEUR CONNECTÉ
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage(sellerId: widget.userId)),
          );

          if (result == true) fetchAllData();
        },
        label: const Text("Vendre"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      )
          : null, // Si c'est un client, pas de bouton flottant
    );
  }
}