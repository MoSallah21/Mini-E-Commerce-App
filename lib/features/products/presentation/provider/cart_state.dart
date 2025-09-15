// ============================================
// Cart Provider - State Management
// ============================================

import 'package:flutter/cupertino.dart';
import '../../domain/entities/cart_Item.dart';

// ==========================
// CartProvider Class
// ==========================
// Manages the shopping cart state across the app.
// Uses ChangeNotifier to notify UI of state changes.
class CartProvider with ChangeNotifier {
  // Internal map to store cart items with product ID as key
  final Map<String, CartItem> _items = {};

  // Getter for all cart items (returns a copy to prevent direct modification)
  Map<String, CartItem> get items => {..._items};

  // Returns the number of unique items in the cart
  int get itemCount => _items.length;

  // Calculates the total price of all items in the cart
  double get totalPrice {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  // ==========================
  // Add item to cart
  // ==========================
  void addItem(CartItem item) {
    if (_items.containsKey(item.id)) {
      // Increase quantity if the item already exists
      _items[item.id]!.quantity += 1;
    } else {
      // Add new item to the cart
      _items[item.id] = item;
    }
    notifyListeners(); // Notify UI to update
  }

  // ==========================
  // Remove item from cart
  // ==========================
  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  // ==========================
  // Update quantity of a specific item
  // ==========================
  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity = quantity;
      notifyListeners();
    }
  }

  // ==========================
  // Clear the entire cart
  // ==========================
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
