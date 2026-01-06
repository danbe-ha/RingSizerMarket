<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;

class ProductController extends Controller
{
    // 1. LISTER LES PRODUITS
    public function index()
    {
        // CORRECTION : On renvoie directement la liste pour que Flutter puisse la lire
        return response()->json(Product::all(), 200);
    }

    // 2. AJOUTER UN PRODUIT
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'title' => 'required|string',
                'weight_g' => 'required|numeric',
                'price_fixed' => 'required|numeric',
                'purity' => 'required|in:18k,22k,24k',
                'seller_id' => 'required|integer',
                'images' => 'nullable|array' // <--- AJOUT IMPORTANT : Autoriser les images
            ]);

            // Si aucune image n'est envoyée, on met un tableau vide par défaut
            if (!isset($validated['images'])) {
                $validated['images'] = [];
            }

            $product = Product::create($validated);
            return response()->json($product, 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json(['errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}