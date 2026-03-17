import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  int get totalItemsCount {
    int count = 0;
    _items.forEach((key, cartItem) {
      count += cartItem.quantity;
    });
    return count;
  }

  double get subtotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get ivaAmount {
    return subtotalAmount * 0.16; // 16% IVA
  }

  double get shippingCost {
    return _items.isEmpty ? 0.0 : 150.0; // Costo fijo, 0 si no hay items
  }

  double get totalAmount {
    return subtotalAmount + ivaAmount + shippingCost;
  }

  void addItem(Product product, {String? size}) {
    // Generate a unique key based on productId and size
    final String cartKey = size != null ? '${product.id}-$size' : product.id;

    if (_items.containsKey(cartKey)) {
      _items.update(
        cartKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          icon: existingCartItem.icon,
          iconColor: existingCartItem.iconColor,
          size: existingCartItem.size,
        ),
      );
    } else {
      _items.putIfAbsent(
        cartKey,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: product.id,
          title: product.title,
          price: product.price,
          quantity: 1,
          icon: product.icon,
          iconColor: product.iconColor,
          size: size,
        ),
      );
    }
    notifyListeners();
  }

  void incrementItemQuantity(String cartKey) {
    if (_items.containsKey(cartKey)) {
      _items.update(
        cartKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          icon: existingCartItem.icon,
          iconColor: existingCartItem.iconColor,
          size: existingCartItem.size,
        ),
      );
      notifyListeners();
    }
  }

  void removeItem(String cartKey) {
    _items.remove(cartKey);
    notifyListeners();
  }

  void removeSingleItem(String cartKey) {
    if (!_items.containsKey(cartKey)) {
      return;
    }
    if (_items[cartKey]!.quantity > 1) {
      _items.update(
        cartKey,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          icon: existingCartItem.icon,
          iconColor: existingCartItem.iconColor,
          size: existingCartItem.size,
        ),
      );
    } else {
      _items.remove(cartKey);
    }
    notifyListeners();
  }

  // Helper for direct rollback from Home (if undoing without size)
  void removeProductCompletely(String productId) {
    _items.removeWhere((key, item) => item.productId == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
