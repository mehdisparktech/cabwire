import 'package:cabwire/core/base/base_entity.dart';

/// Example entity class to demonstrate best practices
class ExampleEntity extends BaseEntity {
  final String? id;
  final String? name;
  final NestedEntity? nestedObject;
  final List<ItemEntity>? items;

  const ExampleEntity({this.id, this.name, this.nestedObject, this.items});

  @override
  List<Object?> get props => [id, name, nestedObject, items];

  /// Creates a copy with optional new values
  ExampleEntity copyWith({
    String? id,
    String? name,
    NestedEntity? nestedObject,
    List<ItemEntity>? items,
  }) {
    return ExampleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nestedObject: nestedObject ?? this.nestedObject,
      items: items ?? this.items,
    );
  }
}

/// Nested entity class example
class NestedEntity extends BaseEntity {
  final String? id;
  final String? name;

  const NestedEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];

  /// Creates a copy with optional new values
  NestedEntity copyWith({String? id, String? name}) {
    return NestedEntity(id: id ?? this.id, name: name ?? this.name);
  }
}

/// Item entity class example
class ItemEntity extends BaseEntity {
  final int? id;
  final String? value;

  const ItemEntity({this.id, this.value});

  @override
  List<Object?> get props => [id, value];

  /// Creates a copy with optional new values
  ItemEntity copyWith({int? id, String? value}) {
    return ItemEntity(id: id ?? this.id, value: value ?? this.value);
  }
}
