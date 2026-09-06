# Views - Laravel CRUD

## Overview
Blade views for CRUD operations.

## View Files
```
resources/views/items/
├── index.blade.php
├── create.blade.php
├── show.blade.php
└── edit.blade.php
```

## Index View (List)
```blade
@extends('layouts.app')

@section('content')
    <h1>Items</h1>
    <a href="{{ route('items.create') }}">Create New Item</a>

    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            @foreach($items as $item)
                <tr>
                    <td>{{ $item->name }}</td>
                    <td>${{ number_format($item->price, 2) }}</td>
                    <td>
                        <a href="{{ route('items.show', $item) }}">View</a>
                        <a href="{{ route('items.edit', $item) }}">Edit</a>
                        <form action="{{ route('items.destroy', $item) }}" method="POST">
                            @csrf
                            @method('DELETE')
                            <button type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            @endforeach
        </tbody>
    </table>
@endsection
```

## Create View (Form)
```blade
@extends('layouts.app')

@section('content')
    <h1>Create Item</h1>

    <form action="{{ route('items.store') }}" method="POST">
        @csrf

        <label>Name:</label>
        <input type="text" name="name" value="{{ old('name') }}">
        @error('name') {{ $message }} @enderror

        <label>Description:</label>
        <textarea name="description">{{ old('description') }}</textarea>

        <label>Price:</label>
        <input type="number" name="price" step="0.01" value="{{ old('price') }}">

        <button type="submit">Create</button>
    </form>
@endsection
```

## Show View (Details)
```blade
@extends('layouts.app')

@section('content')
    <h1>{{ $item->name }}</h1>
    <p>{{ $item->description }}</p>
    <p>Price: ${{ number_format($item->price, 2) }}</p>

    <a href="{{ route('items.edit', $item) }}">Edit</a>
    <a href="{{ route('items.index') }}">Back</a>
@endsection
```

## Edit View (Form)
```blade
@extends('layouts.app')

@section('content')
    <h1>Edit Item</h1>

    <form action="{{ route('items.update', $item) }}" method="POST">
        @csrf
        @method('PUT')

        <label>Name:</label>
        <input type="text" name="name" value="{{ old('name', $item->name) }}">

        <label>Description:</label>
        <textarea name="description">{{ old('description', $item->description) }}</textarea>

        <label>Price:</label>
        <input type="number" name="price" step="0.01" value="{{ old('price', $item->price) }}">

        <button type="submit">Update</button>
    </form>
@endsection
```

## Tags
#laravel #views #blade #crud #frontend
