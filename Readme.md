# 💍 Ring Sizer Market

**Ring Sizer Market** est une application mobile complète permettant de mesurer sa taille de bague ou de poignet, de suivre le cours de l'or en temps réel, et d'acheter ou vendre des bijoux via une marketplace intégrée.

Ce projet repose sur une architecture **Client-Serveur** avec une application **Flutter** (Frontend) et une API REST **Laravel** (Backend).

---

## 🚀 Fonctionnalités Principales

### 🛠 1. Outils Utiles (Accessibles à tous)
- **Ring Sizer Visuel** : Un outil interactif pour mesurer la taille de bague (cercle) ou de poignet (ovale) directement sur l'écran avec un calibrage précis en millimètres.
- **Cours de l'Or** : Visualisation graphique de l'évolution du prix de l'or (18k, 22k, 24k) en temps réel (via API externe GoldAPI).

### 🏪 2. Marketplace (E-Commerce)
- **Système de Rôles** : Inscription en tant que **Client** (Acheteur) ou **Vendeur** (Bijoutier).
- **Gestion des Produits** : Les vendeurs peuvent mettre en ligne leurs bijoux (Titre, Poids, Carats, Prix).
- **Système de Commande** : Les clients peuvent commander des articles. La commande est liée au vendeur spécifique.
- **Historique** :
  - Les vendeurs voient leurs ventes ("Mes Ventes").
  - Les clients voient leurs achats ("Mes Commandes").

---

## 🛠 Technologies Utilisées

- **Frontend (Mobile)** : Flutter (Langage Dart).
- **Backend (API)** : Laravel 10+ (Langage PHP).
- **Base de Données** : MySQL (via XAMPP).
- **Outils de Dév** : Android Studio, Visual Studio Code, Postman.

---

## ⚙️ Installation et Lancement

Pour tester ce projet localement, suivez ces étapes :

### 1. Prérequis
- XAMPP (Apache & MySQL lancés).
- Flutter SDK installé.
- Composer (pour Laravel).

### 2. Configuration du Backend (Laravel)
```bash
cd RingSizerBackend
cp .env.example .env
# Configurez votre base de données dans .env (DB_DATABASE=ring_sizer)
composer install
php artisan key:generate
php artisan migrate:fresh
php artisan serve

Le serveur API sera accessible sur http://127.0.0.1:8000.

### 3. Lancement de l'Application (Flutter)
```bash
cd RingSizerApp
flutter pub get
flutter run
Note : L'application est configurée pour communiquer avec l'API via 10.0.2.2 (IP spéciale pour l'émulateur Android).

👤 Auteur & Contexte
Projet réalisé par : Benrioui Ali & Eddanir Rajaa Cadre : Projet de fin de module - Développement Mobile.