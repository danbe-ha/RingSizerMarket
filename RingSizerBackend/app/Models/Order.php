<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    // On autorise Laravel à remplir ces champs
    protected $fillable = [
        'user_id',
        'seller_id',
        'product_id',
        'qty',
        'total_price',
        'status'
    ];
}