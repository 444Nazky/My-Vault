# Model - Laravel CRUD

## Overview
Laravel Eloquent Model for CRUD operations.

## Create Model
```bash
php artisan make:model Item
```

## Model Structure
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    // Table name (optional)
    protected $table = 'items';

    // Primary key (optional)
    protected $primaryKey = 'id';

    // Timestamps (optional)
    public $timestamps = true;

    // Fillable fields
    protected $fillable = [
        'name',
        'description',
        'price',
        'category_id'
    ];

    // Hidden fields
    protected $hidden = [
        'password'
    ];
}
```

## CRUD Methods

### Create
```php
// Method 1
$item = new Item();
$item->name = 'Product';
$item->save();

// Method 2
Item::create([
    'name' => 'Product',
    'description' => 'Description',
    'price' => 99.99
]);
```

### Read
```php
// Get all
$items = Item::all();

// Find by ID
$item = Item::find($id);

// Where clause
$items = Item::where('price', '>', 50)->get();
```

### Update
```php
$item = Item::find($id);
$item->name = 'Updated Name';
$item->save();

// Or
Item::where('id', $id)->update(['name' => 'New Name']);
```

### Delete
```php
$item = Item::find($id);
$item->delete();

// Or
Item::destroy($id);

// Or
Item::where('id', $id)->delete();
```

## Relationships
```php
// One to Many
public function items()
{
    return $this->hasMany(Item::class);
}

// Many to One
public function category()
{
    return $this->belongsTo(Category::class);
}
```

## Tags
#crud
