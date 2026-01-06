<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateGoldPricesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
{
    Schema::create('gold_prices', function (Blueprint $table) {
        $table->id();
        $table->date('date');
        $table->decimal('price_24k', 12, 4);
        $table->decimal('price_22k', 12, 4);
        $table->decimal('price_18k', 12, 4);
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
        Schema::dropIfExists('gold_prices');
    }
}
