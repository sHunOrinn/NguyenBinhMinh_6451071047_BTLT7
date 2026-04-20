import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl =
      'https://69ddbb8f410caa3d47b9e4e6.mockapi.io/products';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Không tải được sản phẩm');
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'search': keyword,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Search thất bại');
    }
  }
}