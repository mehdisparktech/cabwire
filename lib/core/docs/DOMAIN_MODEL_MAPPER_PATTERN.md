# Domain Entity, Data Model, and Mapper Best Practices

This document outlines the best practices for implementing the domain entities, data models, and mappers in the Cabwire project.

## Architecture Overview

Our project follows a clean architecture approach with clear separation between:

1. **Domain Layer** - Contains business logic and entities
2. **Data Layer** - Handles data operations and transformations
3. **Presentation Layer** - Manages UI and user interactions

## Domain Entities

Domain entities represent the core business objects and should:

- Extend `BaseEntity` from `core/base/base_entity.dart`
- Use nullable types (`String?`, `int?`, etc.) for properties
- Implement `props` getter for Equatable comparison
- Include `copyWith()` method for immutability
- Be pure Dart classes without JSON serialization logic
- Contain minimal business logic related to the entity
- Use descriptive names with the `Entity` suffix

Example:
```dart
class UserEntity extends BaseEntity {
  final String? id;
  final String? name;
  final String? email;

  const UserEntity({
    this.id,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, email];

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

## Data Models

Data models handle serialization/deserialization and should:

- Use standalone classes (not extending entities)
- Include `fromJson` and `toJson` methods for serialization
- Handle null safety with default values
- Use non-nullable types where appropriate
- Implement `copyWith()` method for immutability
- Use descriptive names with the `Model` suffix

Example:
```dart
class UserModel {
  final String? id;
  final String name;
  final String email;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

## Mappers

Mappers convert between entities and models and should:

- Use extension methods on models and entities
- Be implemented in separate files named `*_mapper.dart`
- Handle null values appropriately
- Convert nested objects and collections
- Include bidirectional mapping (entity to model and vice versa)
- Be pure functions without side effects

Example:
```dart
extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
    );
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name ?? '',
      email: email ?? '',
    );
  }
}
```

## Nested Objects

For nested objects:

1. Create separate entity and model classes for the nested object
2. Handle null safety for nested objects in mappers
3. Convert collections using `map()` transformations

Example:
```dart
// Entity with nested object
class OrderEntity extends BaseEntity {
  final String? id;
  final CustomerEntity? customer;
  final List<OrderItemEntity>? items;
  
  // ...
}

// Mapper handling nested objects
extension OrderModelMapper on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      customer: customer != null ? CustomerEntity(
        id: customer!.id,
        name: customer!.name,
      ) : null,
      items: items?.map((item) => OrderItemEntity(
        id: item.id,
        productId: item.productId,
        quantity: item.quantity,
      )).toList(),
    );
  }
}
```

## Null Safety Best Practices

1. Use nullable types (`String?`, `int?`) in entities
2. Use non-nullable types with default values in models
3. Handle null values in mappers with `??` operator or conditional logic
4. Check for null before accessing nested properties
5. Provide defaults for primitive types (`0`, `''`, `[]`, etc.)

## File Organization

- **Entities**: `lib/domain/entities/[domain_area]/[entity_name].dart`
- **Models**: `lib/data/models/[domain_area]/[model_name].dart`
- **Mappers**: `lib/data/mappers/[domain_area]/[entity_name]_mapper.dart`

## References

For more examples, check:
- `lib/domain/entities/example_entity.dart`
- `lib/data/models/example_model.dart`
- `lib/data/mappers/example_mapper_template.dart` 