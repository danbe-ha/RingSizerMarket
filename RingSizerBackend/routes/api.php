<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// On importe les contrôleurs qu'on va utiliser
use App\Http\Controllers\ProductController;
use App\Http\Controllers\GoldPriceController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\AuthController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


// === Routes pour l'API RingSizer ===

// Obtenir la liste de tous les produits
Route::get('/products', [ProductController::class, 'index']);

// Créer un nouveau produit
Route::post('/products', [ProductController::class, 'store']);

// Obtenir le dernier prix de l'or
Route::get('/gold-price', [GoldPriceController::class, 'getLatestPrice']);

Route::post('/gold-price/refresh', [GoldPriceController::class, 'updatePriceFromApi']);

Route::post('/orders', [OrderController::class, 'store']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/orders', [OrderController::class, 'index']);