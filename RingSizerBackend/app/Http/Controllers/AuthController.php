<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
// use App\Models\Seller; // J'ai commenté ça pour éviter l'erreur

class AuthController extends Controller
{
    // INSCRIPTION
    public function register(Request $request)
    {
        $fields = $request->validate([
            'name' => 'required|string',
            'email' => 'required|string|unique:users,email',
            'password' => 'required|string',
            'role' => 'required|in:user,seller'
        ]);

        // Création de l'utilisateur (C'est la seule chose importante pour l'instant)
        $user = User::create([
            'name' => $fields['name'],
            'email' => $fields['email'],
            'password' => bcrypt($fields['password']),
            'role' => $fields['role']
        ]);

        // J'AI SUPPRIMÉ LE BLOC "Seller::create" QUI FAISAIT PLANTER L'APPLI
        // L'utilisateur est quand même enregistré comme "Vendeur" grâce à la ligne 'role' juste au-dessus.

        return response()->json(['message' => 'Compte créé ! Connectez-vous.', 'user' => $user], 201);
    }

    // CONNEXION (Je n'ai rien touché ici, c'était bon)
    public function login(Request $request)
    {
        $fields = $request->validate([
            'email' => 'required|string',
            'password' => 'required|string'
        ]);

        $user = User::where('email', $fields['email'])->first();

        if(!$user || !Hash::check($fields['password'], $user->password)) {
            return response()->json(['message' => 'Email ou mot de passe incorrect'], 401);
        }

        return response()->json([
            'message' => 'Connexion réussie',
            'user' => $user,
            'role' => $user->role
        ], 200);
    }
}