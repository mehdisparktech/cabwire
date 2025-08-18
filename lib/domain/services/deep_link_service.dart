import 'package:fpdart/fpdart.dart';

abstract class DeepLinkService {
  Future<void> initialize();
  Future<Either<String, String?>> handleInitialLink();
  Stream<String> get linkStream;
  void dispose();
}
