<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $fillable = [
    'seller_id', 'title', 'description', 'purity', 
    'weight_g', 'price_fixed', 'price_dynamic_flag', 
    'images', 'availability'
];

protected $casts = [
    'images' => 'array', // Pour que JSON devienne un tableau automatiquement
];
    use HasFactory;
}
