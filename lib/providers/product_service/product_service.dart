import 'dart:convert';

import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/user.dart'; // Import the User model
import 'package:http/http.dart' as http;

class ProductService {
  Future<List<Product>> getProduct() async {
    var response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<User> getUser() async {
    var response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/users/1'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
