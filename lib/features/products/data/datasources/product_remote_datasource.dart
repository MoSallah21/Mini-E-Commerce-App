// ============================================
// Product Remote Datasource - Firestore CRUD
// ============================================

// Core imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/result.dart';

import '../models/product_model.dart';

// ==========================
// Abstract Datasource
// ==========================
// Defines the contract for product-related remote operations.
// Uses a generic Result<T> wrapper to handle success and failure cases.
abstract class ProductRemoteDatasource {
  // Fetch all products from Firestore
  Future<Result<List<ProductModel>>> getProducts();

  // Fetch a single product by its ID
  Future<Result<ProductModel>> getProductById(String id);

  // Add a new product to Firestore
  Future<Result<void>> addProduct(ProductModel product);

  // Update an existing product
  Future<Result<void>> updateProduct(ProductModel product);

  // Delete a product by ID
  Future<Result<void>> deleteProduct(String id);
}

// ==========================
// Implementation using Firestore
// ==========================
class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final FirebaseFirestore _firestore; // Firestore instance
  final String _collection = 'products'; // Collection name

  // Constructor with optional Firestore instance for testing or dependency injection
  ProductRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // ==========================
  // Fetch all products
  // ==========================
  @override
  Future<Result<List<ProductModel>>> getProducts() async {
    try {
      // Retrieve all documents from 'products' collection
      final snapshot = await _firestore.collection(_collection).get();

      // Convert each document to ProductModel
      final products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();

      return Result.success(products); // Return success result
    } catch (e) {
      return Result.failure(e.toString()); // Return failure with error message
    }
  }

  // ==========================
  // Fetch a single product by ID
  // ==========================
  @override
  Future<Result<ProductModel>> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists) {
        return Result.success(ProductModel.fromJson(doc.data()!));
      } else {
        return Result.failure('Product not found'); // Product does not exist
      }
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // ==========================
  // Add a new product
  // ==========================
  @override
  Future<Result<void>> addProduct(ProductModel product) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(product.id) // Use product ID as document ID
          .set(product.toJson()); // Convert model to JSON
      return Result.success(null); // Void success
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // ==========================
  // Update an existing product
  // ==========================
  @override
  Future<Result<void>> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(product.id)
          .update(product.toJson()); // Update fields with model data
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  // ==========================
  // Delete a product by ID
  // ==========================
  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
