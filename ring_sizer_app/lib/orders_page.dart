import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  final String userRole;
  final int userId;

  const OrdersPage({super.key, required this.userRole, required this.userId});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    // ⚠️ Si tu es sur émul, garde 10.0.2.2. Si vrai tél, mets ton IP (192.168...)
    final String baseUrl = "http://10.0.2.2:8000/api/orders";

    try {
      final response = await http.get(
          Uri.parse("$baseUrl?user_id=${widget.userId}&role=${widget.userRole}")
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Erreur : $e");
      if(mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userRole == 'seller' ? "Mes Ventes" : "Mes Commandes"),
        backgroundColor: widget.userRole == 'seller' ? Colors.black : Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text("Aucune commande pour l'instant."))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final item = orders[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(
                widget.userRole == 'seller' ? Icons.sell : Icons.shopping_bag,
                color: Colors.green,
              ),
              title: Text(item['product_name'] ?? "Bijou inconnu"), // Sécurité si nom vide
              subtitle: Text("Prix : ${item['total_price'] ?? item['product_price'] ?? 0} MAD"),
              // Sécurité sur la date :
              trailing: Text(
                (item['created_at'] != null && item['created_at'].toString().length >= 10)
                    ? item['created_at'].toString().substring(0, 10)
                    : "Date inconnue",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}