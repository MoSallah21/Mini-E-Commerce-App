// ============================================
// Product State - State Management (Provider)
// ============================================

import 'package:ecommerce/core/utils/result.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/usecases/get_product_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter/material.dart';

// ==========================
// ProductState Class
// ==========================
// Manages the state for product listing and details.
// Handles loading, error messages, search filtering, and data fetching.
// Uses ChangeNotifier to update UI when state changes.
class ProductState extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final GetProductUseCase getProductUseCase;

  // Private state variables
  bool _isLoading = false;
  List<ProductEntity> _products = [];
  String? _errorMessage;
  String _searchQuery = '';

  // Constructor with required use cases
  ProductState({
    required this.getProductsUseCase,
    required this.getProductUseCase,
  });

  // ==========================
  // Getters
  // ==========================
  bool get isLoading => _isLoading;
  List<ProductEntity> get products => _products;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Returns products filtered by search query (name or category)
  List<ProductEntity> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) =>
    product.name!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.category!.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  // ==========================
  // Set search query and notify listeners
  // ==========================
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ==========================
  // Load products from use case
  // ==========================
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getProductsUseCase.call();

      result.when(
        success: (productsData) {
          _products = productsData;
          _errorMessage = null;
        },
        failure: (error) {
          _products = [];
          _errorMessage = error.toString();
        },
      );
    } catch (e) {
      _products = [];
      _errorMessage = 'Unexpected error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is finished
    }
  }

  // ==========================
  // Refresh products list (re-fetch)
  // ==========================
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // ==========================
  // Clear error message
  // ==========================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
