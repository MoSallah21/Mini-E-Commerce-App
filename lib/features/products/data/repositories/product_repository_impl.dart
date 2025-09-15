// ============================================
// Product Repository Implementation
// ============================================

// Imports
import 'package:ecommerce/features/products/data/datasources/product_remote_datasource.dart';
import '../../domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/data/models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import 'package:ecommerce/core/utils/result.dart';

// ==========================
// ProductRepositoryImpl
// ==========================
// Implements ProductRepository interface to handle business logic for products.
// Converts between ProductModel (data layer) and ProductEntity (domain layer)
// while delegating CRUD operations to ProductRemoteDatasource.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _remoteDataSource;

  // Constructor with required remote data source
  ProductRepositoryImpl({required ProductRemoteDatasource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  // ==========================
  // Fetch all products
  // ==========================
  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    // Call remote data source
    final result = await _remoteDataSource.getProducts();

    // Map Result<List<ProductModel>> to Result<List<ProductEntity>>
    return result.when(
      success: (products) => Result.success(products.cast<ProductEntity>()),
      failure: (error) => Result.failure(error),
    );
  }

  // ==========================
  // Fetch single product by ID
  // ==========================
  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    final result = await _remoteDataSource.getProductById(id);

    // Map Result<ProductModel> to Result<ProductEntity>
    return result.when(
      success: (product) => Result.success(product as ProductEntity),
      failure: (error) => Result.failure(error),
    );
  }

  // ==========================
  // Add new product
  // ==========================
  @override
  Future<Result<void>> addProduct(ProductEntity product) async {
    // Convert ProductEntity to ProductModel for remote data source
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      quantity: product.quantity,
      createdAt: product.createdAt,
    );

    // Delegate add operation to remote datasource
    return await _remoteDataSource.addProduct(productModel);
  }

  // ==========================
  // Update existing product
  // ==========================
  @override
  Future<Result<void>> updateProduct(ProductEntity product) async {
    // Convert ProductEntity to ProductModel
    final productModel = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      quantity: product.quantity,
      createdAt: product.createdAt,
    );

    // Delegate update operation to remote datasource
    return await _remoteDataSource.updateProduct(productModel);
  }

  // ==========================
  // Delete product by ID
  // ==========================
  @override
  Future<Result<void>> deleteProduct(String id) async {
    // Delegate delete operation to remote datasource
    return await _remoteDataSource.deleteProduct(id);
  }
}
