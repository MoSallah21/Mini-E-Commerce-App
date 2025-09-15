// ============================================
// GetProductsUseCase - Domain Layer Use Case
// ============================================

import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

// ==========================
// GetProductsUseCase Class
// ==========================
// Handles the business logic for fetching the list of all products.
// Acts as an intermediary between the UI (or state management) and the repository.
class GetProductsUseCase {
  final ProductRepository productRepository;

  // Constructor injecting the repository
  GetProductsUseCase(this.productRepository);

  // ==========================
  // Call method to execute the use case
  // ==========================
  // Fetches all products and returns a Result containing
  // either a list of ProductEntity on success or an error message on failure.
  Future<Result<List<ProductEntity>>> call() async {
    return await productRepository.getProducts();
  }
}
