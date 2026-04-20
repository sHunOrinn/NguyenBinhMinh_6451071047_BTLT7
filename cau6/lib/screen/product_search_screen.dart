import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;

  Future<void> _searchProducts() async {
    final keyword = _searchController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final result = keyword.isEmpty
          ? await _productService.getProducts()
          : await _productService.searchProducts(keyword);

      setState(() {
        _products = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi search: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildProductItem(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: product.image.isNotEmpty
            ? Image.network(
          product.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        )
            : const Icon(Icons.image),
        title: Text(product.name),
        subtitle: Text(product.desc),
        trailing: Text('${product.price}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products - Nguyễn Bình Minh - 6451071047'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập từ khóa...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchProducts(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchProducts,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (_products.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Không có kết quả'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductItem(_products[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}