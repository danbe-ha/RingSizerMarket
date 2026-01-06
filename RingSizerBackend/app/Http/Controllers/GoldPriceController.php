<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\GoldPrice;
use Illuminate\Support\Facades\Http;
class GoldPriceController extends Controller
{
    public function getLatestPrice()
    {
        // Récupère le dernier prix enregistré par date décroissante
        $price = GoldPrice::orderBy('id', 'desc')->first();

        if (!$price) {
            return response()->json(['message' => 'Prix non disponible'], 404);
        }

        return response()->json($price, 200);
    }
    // Nouvelle fonction pour récupérer le VRAI prix via Internet
    public function updatePriceFromApi()
    {
        $apiKey = "goldapi-f16dsmj0h6ncf-io"; // <--- REMETS TA CLÉ ICI !

        try {
            // CORRECTION : On demande le prix en DOLLARS (USD) car MAD ne marche pas
            $response = Http::withoutVerifying()->withHeaders([
                'x-access-token' => $apiKey,
                'Content-Type' => 'application/json'
            ])->get('https://www.goldapi.io/api/XAU/USD');

            if ($response->successful()) {
                $data = $response->json();
                
                if (isset($data['error'])) {
                    return response()->json(['error' => 'GoldAPI: ' . $data['error']], 500);
                }

                // 1. Récupérer le prix d'une once en DOLLARS
                $pricePerOunceUSD = $data['price'];

                // 2. Convertir en DIRHAMS (Taux approx : 1 USD = 10.2 MAD)
                // Tu peux ajuster ce taux si tu veux
                $rateUsdToMad = 10.2; 
                $pricePerOunceMAD = $pricePerOunceUSD * $rateUsdToMad;

                // 3. Convertir en Grammes (1 once = 31.1035g)
                $pricePerGram24k = $pricePerOunceMAD / 31.1035;
                
                // 4. Calculer les autres carats
                $pricePerGram22k = $pricePerGram24k * 0.916;
                $pricePerGram18k = $pricePerGram24k * 0.750;

                // Sauvegarde
                $goldPrice = new GoldPrice();
                $goldPrice->date = now();
                $goldPrice->price_24k = $pricePerGram24k;
                $goldPrice->price_22k = $pricePerGram22k;
                $goldPrice->price_18k = $pricePerGram18k;
                $goldPrice->save();

                return response()->json(['message' => 'Prix (USD->MAD) mis à jour !', 'data' => $goldPrice], 200);
            } else {
                return response()->json(['error' => 'Échec HTTP: ' . $response->status()], 500);
            }
        } catch (\Exception $e) {
            return response()->json(['error' => 'Exception: ' . $e->getMessage()], 500);
        }
    }
}