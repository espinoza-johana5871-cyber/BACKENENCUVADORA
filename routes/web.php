<?php

use Illuminate\Support\Facades\Route;

<<<<<<< HEAD
Route::get('/', function () {
    return view('welcome');
});
=======
Route::get('/{any?}', function () {
    return view('app');
})->where('any', '.*');
>>>>>>> f19f637fe0187796c64592efa3a3edb8c3f27e5a
