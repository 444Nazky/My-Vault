# Validation

## Overview
Laravel validation rules for CRUD operations.

## Common Rules
- required
- nullable
- string, numeric, integer
- min:value, max:value
- unique:table,column
- email, url, ip
- confirmed (for password confirmation)

## Custom Messages
```php
public function messages()
{
    return [
        'name.required' => 'Name is required',
        'price.numeric' => 'Price must be a number',
    ];
}
```

## Tags
#crud
