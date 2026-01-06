<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GoldPrice extends Model
{
    protected $fillable = ['date', 'price_24k', 'price_22k', 'price_18k'];
    use HasFactory;
}
