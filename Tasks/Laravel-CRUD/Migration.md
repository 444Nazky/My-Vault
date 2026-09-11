# Migration - Laravel CRUD

## Overview
Laravel database migration for CRUD operations.

## Create Migration
```bash
php artisan make:migration create_items_table
```

## Migration Structure
```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateItemsTable extends Migration
{
    public function up()
    {
        Schema::create('items', function (Blueprint $table) {
            $table->id();              // Auto-increment ID
            $table->string('name');      // VARCHAR
            $table->text('description')->nullable();
            $table->decimal('price', 8, 2);
            $table->unsignedBigInteger('category_id')->nullable();
            $table->timestamps();        // created_at & updated_at
            $table->softDeletes();       // deleted_at

            // Foreign key
            $table->foreign('category_id')
                ->references('id')
                ->on('categories')
                ->onDelete('set null');
        });
    }

    public function down()
    {
        Schema::dropIfExists('items');
    }
}
```

## Column Types
```php
$table->id();           // Big increments ID
$table->string('name'); // VARCHAR 255
$table->text('bio');    // TEXT
$table->integer('age'); // Integer
$table->boolean('active'); // Boolean
$table->decimal('price', 8, 2); // Decimal
$table->date('date');  // Date
$table->timestamp('created_at'); // Timestamp
$table->json('data'); // JSON
$table->uuid('uuid'); // UUID
```

## Column Modifiers
```php
$table->string('email')->unique();
$table->string('name')->nullable();
$table->string('name')->default('John');
$table->string('name')->comment('User name');
```

## Indexes
```php
$table->primary('id');
$table->unique('email');
$table->index('category_id');
$table->index(['name', 'price']);
```

## Run Migrations
```bash
php artisan migrate
php artisan migrate:rollback    # Undo last migration
php artisan migrate:refresh     # Reset and re-run
php artisan migrate:fresh      # Drop all and re-run
```

## Tags
#database
