// ============================================
// Product Repository Interface - Domain Layer
// ============================================

// Core imports
import 'package:ecommerce/core/utils/result.dart';

import '../entities/product_entity.dart';

// ==========================
// Abstract Repository
// ==========================
// Defines the contract for product-related operations at the domain layer.
// All methods return a Result<T> to handle success and failure scenarios.
// This interface decouples business logic from data sources (remote/local).
abstract class ProductRepository {
  // Fetch all products
  Future<Result<List<ProductEntity>>> getProducts();

  // Fetch a single product by its unique ID
  Future<Result<ProductEntity>> getProductById(String id);

  // Add a new product
  Future<Result<void>> addProduct(ProductEntity product);

  // Update an existing product
  Future<Result<void>> updateProduct(ProductEntity product);

  // Delete a product by its ID
  Future<Result<void>> deleteProduct(String id);
}
