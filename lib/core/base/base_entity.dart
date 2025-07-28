import 'package:equatable/equatable.dart';

/// Base class for all domain entities
///
/// Provides equality comparison through Equatable and
/// enforces implementation of props for proper comparison
abstract class BaseEntity extends Equatable {
  const BaseEntity();

  @override
  bool get stringify => true;
}
