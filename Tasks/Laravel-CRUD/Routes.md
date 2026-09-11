# Routes - Laravel CRUD

## Overview
Laravel routes for CRUD operations.

## Route File Location
`routes/web.php`

## Basic Routes
```php
// Display all items
Route::get('/items', [ItemController::class, 'index']);

// Show create form
Route::get('/items/create', [ItemController::class, 'create']);

// Store new item
Route::post('/items', [ItemController::class, 'store']);

// Show single item
Route::get('/items/{item}', [ItemController::class, 'show']);

// Show edit form
Route::get('/items/{item}/edit', [ItemController::class, 'edit']);

// Update item
Route::put('/items/{item}', [ItemController::class, 'update']);

// Delete item
Route::delete('/items/{item}', [ItemController::class, 'destroy']);
```

## Resource Routes (Shorthand)
```php
// All CRUD routes in one line
Route::resource('items', ItemController::class);
```

## Named Routes
```php
Route::get('/items', [ItemController::class, 'index'])->name('items.index');
Route::post('/items', [ItemController::class, 'store'])->name('items.store');
```

## Route Parameters
```php
// Required parameter
Route::get('/items/{id}', ...);

// Optional parameter
Route::get('/items/{id?}', ...);

// Multiple parameters
Route::get('/users/{user}/items/{item}', ...);
```

## Tags
#crud #php
