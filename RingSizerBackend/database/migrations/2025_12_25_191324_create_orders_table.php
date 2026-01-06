<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrdersTable extends Migration
{
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            
            // L'acheteur (celui qui est connecté)
            $table->unsignedBigInteger('user_id');
            
            // Le vendeur (celui qui a mis le produit en vente)
            $table->unsignedBigInteger('seller_id')->nullable(); 
            
            // Le produit acheté
            $table->unsignedBigInteger('product_id');

            $table->integer('qty')->default(1); // Quantité (1 par défaut)
            $table->decimal('total_price', 10, 2); // Prix total payé
            
            $table->string('status')->default('en_attente'); // Statut de la commande
            
            $table->timestamps(); // Crée created_at et updated_at
        });
    }

    public function down()
    {
        Schema::dropIfExists('orders');
    }
}