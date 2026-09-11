# Form Requests

## Overview
Laravel Form Request classes for validation.

## Create Form Request
```bash
php artisan make:request StoreItemRequest
php artisan make:request UpdateItemRequest
```

## StoreItemRequest
```php
public function rules()
{
    return [
        'name' => 'required|string|max:255',
        'description' => 'nullable|string',
        'price' => 'required|numeric|min:0',
    ];
}
```

## Tags
#crud
