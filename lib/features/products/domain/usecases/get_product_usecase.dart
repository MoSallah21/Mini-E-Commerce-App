// ============================================
// GetProductUseCase - Domain Layer Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

// ==========================
// GetProductUseCase Class
// ==========================
// Handles the business logic for fetching a single product by its ID.
// Acts as an intermediary between the UI (or state management) and the repository.
class GetProductUseCase {
  final ProductRepository productRepository;

  // Constructor injecting the repository
  GetProductUseCase(this.productRepository);

  // ==========================
  // Call method to execute the use case
  // ==========================
  // Accepts a product ID and returns a Result<ProductEntity>
  // indicating success or failure.
  Future<Result<ProductEntity>> call(String id) async {
    return await productRepository.getProductById(id);
  }
}
