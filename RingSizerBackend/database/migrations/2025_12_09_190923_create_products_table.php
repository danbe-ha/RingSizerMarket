<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
{
    Schema::create('products', function (Blueprint $table) {
        $table->id();
        $table->unsignedBigInteger('seller_id')->nullable();
        $table->string('title');
        $table->text('description')->nullable();
        $table->enum('purity', ['24k', '22k', '18k']);
        $table->decimal('weight_g', 10, 3);
        $table->decimal('price_fixed', 12, 2)->nullable();
        $table->boolean('price_dynamic_flag')->default(true);
        $table->json('images')->nullable();
        $table->boolean('availability')->default(true);
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products');
    }
}
