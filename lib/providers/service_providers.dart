import 'dart:async';

import 'package:e_commerce/models/cart_item.dart';
import 'package:e_commerce/models/location.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/providers/product_service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ServiceProviders extends ChangeNotifier {
  ServiceProviders();

  ProductService productService = ProductService();
  String? _errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Product> _product = [];
  List<Product> get product => _product;

  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  final List<Product> _favoriteItems = [];
  List<Product> get favoriteItems => _favoriteItems;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  User? _user;
  User? get user => _user;

  String? _deliveryLocation;
  String? _deliveryLocationNote;

  String? get deliveryLocation => _deliveryLocation;
  String? get deliveryLocationNote => _deliveryLocationNote;

  void setDeliveryLocation(String location, {String? note}) {
    _deliveryLocation = location;
    _deliveryLocationNote = note;
    notifyListeners();
  }

  void reset() {
    _cartItems.clear();
    _selectedCategory = null;
    _user = null;
    _deliveryLocation = null;
    _deliveryLocationNote = null;
    notifyListeners();
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      return '${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
    } catch (err) {
      debugPrint(err.toString());
      return 'Unknown Location';
    }
  }

  final List<LocationProvider> locationProvider = [];

  void addLocation(LocationProvider item) {
    locationProvider.add(
      LocationProvider(
        location: item.location,
        lat: item.lat,
        lng: item.lng,
        note: item.note,
      ),
    );
    notifyListeners();
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _product;
    } else if (_selectedCategory == 'Others') {
      return _product
          .where((p) =>
              p.category!.name != 'Clothes' &&
              p.category!.name != 'Electronics' &&
              p.category!.name != 'Shoes' &&
              p.category!.name != 'Furniture')
          .toList();
    } else {
      return _product
          .where((p) => p.category!.name == _selectedCategory)
          .toList();
    }
  }

  Future<void> fetchProduct() async {
    _isLoading = true;
    notifyListeners();

    try {
      _product = await productService
          .getProduct()
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      _errorMessage = "Request Timeout";
    } catch (e) {
      _errorMessage = "Error : $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user =
          await productService.getUser().timeout(const Duration(seconds: 10));
    } on TimeoutException {
      _errorMessage = "Request Timeout";
    } catch (e) {
      _errorMessage = "Error : $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  void addToCart(Product product) {
    final index =
        _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartItemQuantity(Product product, int quantity) {
    if (quantity < 1) {
      _cartItems.removeWhere((item) => item.product.id == product.id);
    } else {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cartItems[index].quantity = quantity;
      }
    }
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final product = _product.firstWhere((item) => item.id == productId);
    if (_favoriteItems.contains(product)) {
      _favoriteItems.remove(product);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }
}
