import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const String _productsUrl =
      'https://fakestoreapi.com/products';

  String _productUrlById(int id) => '$_productsUrl/$id';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_productsUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((dynamic item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse(_productUrlById(id)));

    if (response.statusCode != 200) {
      throw Exception('Failed to load product. Status: ${response.statusCode}');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}