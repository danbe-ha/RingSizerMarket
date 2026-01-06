<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;
use App\Models\Product;

class OrderController extends Controller
{
    // Fonction pour créer une commande
    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'price' => 'required|numeric',
            'user_id' => 'required|integer', // L'acheteur
        ]);

        // 1. ON CHERCHE LE PRODUIT D'ABORD
        $product = \App\Models\Product::findOrFail($request->product_id);

        $order = new Order();
        $order->user_id = $request->user_id; // L'acheteur (Client)
        
        // 2. CORRECTION CRUCIALE ICI : 
        // On ne met pas "1" par défaut. On prend le VRAI vendeur du produit.
        $order->seller_id = $product->seller_id; 

        $order->product_id = $request->product_id;
        $order->qty = 1;
        $order->total_price = $request->price;
        $order->status = 'en_attente';
        
        $order->save();

        return response()->json(['message' => 'Commande reçue !', 'order' => $order], 201);
    }

    // Fonction pour voir l'historique (Celle-ci était déjà bonne)
    public function index(Request $request)
    {
        $userId = $request->query('user_id');
        $role = $request->query('role');

        $query = Order::join('products', 'orders.product_id', '=', 'products.id')
                      ->select('orders.*', 'products.title as product_name', 'products.price_fixed as product_price');

        if ($role == 'seller') {
            // Le vendeur voit ses ventes
            $query->where('orders.seller_id', $userId);
        } else {
            // Le client voit ses achats
            $query->where('orders.user_id', $userId);
        }

        $orders = $query->orderBy('orders.created_at', 'desc')->get();
        return response()->json($orders);
    }
}