<?php

use App\Http\Controllers\RegisterController;
use App\Http\Controllers\TodoController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/todo/{author}', [TodoController::class, 'index']);
    Route::post('/createTodo', [TodoController::class, 'store']);
    Route::put('/updateTodo/{id}', [TodoController::class, 'update']);
    Route::delete('/deleteTodo/{id}', [TodoController::class, 'destroy']);
});
// Route::middleware('auth:sanctum')->post('/createTodo', [TodoController::class, 'store']);

Route::controller(RegisterController::class)->group(function () {
    Route::post('register', 'register');
    Route::post('requestToken', 'requestToken');
});