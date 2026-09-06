# Eloquent Relationships

## Overview
Laravel Eloquent relationships for CRUD.

## One to Many
```php
// Model with posts
public function posts()
{
    return $this->hasMany(Post::class);
}

// Related model
public function user()
{
    return $this->belongsTo(User::class);
}
```

## Many to Many
```php
public function roles()
{
    return $this->belongsToMany(Role::class);
}
```

## Tags
#laravel #eloquent #relationships #crud
