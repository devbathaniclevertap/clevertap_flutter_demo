import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/models/cart_item.dart';
import 'package:flutter_clevertap_demo/models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += double.parse(cartItem.product.price) * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          product: product,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  String titleOffer = 'Just Joined? Enjoy Your Exclusive Welcome Pack 🎉';
  List<String> bannerImages = [
    "https://cdn.shopify.com/s/files/1/1454/5188/files/website_banner_1789f18c-a41e-4abd-bef5-5efcbe1a5e5b.jpg?v=1610952312"
  ];
  List<String> frequentlyBoughtProducts = [
    "https://cdn.shopify.com/s/files/1/1454/5188/files/website_banner_1789f18c-a41e-4abd-bef5-5efcbe1a5e5b.jpg?v=1610952312"
  ];
  void getAdUnits() async {
    List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();

    for (var element in displayUnits!) {
      var customExtras = element["custom_kv"];
      if (customExtras != null) {
        print("Display Units CustomExtras: $customExtras");
        if (customExtras['title'] != null) {
          // Assuming customExtras is a Map and contains a 'title' key
          titleOffer = customExtras['title'] ?? '';
        }

        // Use the 'bannerImage' value from customExtras and store it in bannerImages as a List<String>
        if (customExtras['bannerImage'] != null) {
          var bannerImageValue = customExtras['bannerImage'];
          print(bannerImageValue);
          if (bannerImageValue != null) {
            if (bannerImageValue is String) {
              try {
                var decoded = jsonDecode(bannerImageValue);
                if (decoded is List) {
                  bannerImages = List<String>.from(decoded);
                }
              } catch (e) {
                print('Error decoding bannerImageValue: $e');
              }
            } else if (bannerImageValue is List) {
              bannerImages = List<String>.from(bannerImageValue);
            }
          }
        }

        if (customExtras['products'] != null) {
          var frequentlyBoughtProducts = customExtras['products'];
          print(frequentlyBoughtProducts);
          if (frequentlyBoughtProducts != null) {
            if (frequentlyBoughtProducts is String) {
              try {
                var decoded = jsonDecode(frequentlyBoughtProducts);
                if (decoded is List) {
                  this.frequentlyBoughtProducts = List<String>.from(decoded);
                }
              } catch (e) {
                print('Error decoding frequentlyBoughtProducts: $e');
              }
            } else if (frequentlyBoughtProducts is List) {
              this.frequentlyBoughtProducts =
                  List<String>.from(frequentlyBoughtProducts);
            }
          }
        }

        notifyListeners();
      }
    }
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    print("Display Units = $displayUnits");
  }
}
