class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String desc;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.desc,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      image: json['image'] ?? '',
      desc: json['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'desc': desc,
    };
  }
}