import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService {
  static const String _productsUrl =
      'https://69ddbb8f410caa3d47b9e4e6.mockapi.io/product';

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

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(data);
    }

    // Fallback: API detail 404 nhưng list vẫn có dữ liệu
    if (response.statusCode == 404) {
      final products = await fetchProducts();
      return products.firstWhere(
            (p) => p.id == id,
        orElse: () => throw Exception('Product $id not found in list.'),
      );
    }

    throw Exception('Failed to load product. Status: ${response.statusCode}');
  }

}