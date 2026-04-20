class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dynamic rawRating = json['rating'];

    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rating: rawRating is Map<String, dynamic>
          ? Rating.fromJson(rawRating)
          : const Rating(rate: 0, count: 0),
    );
  }
}

class Rating {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: double.tryParse(json['rate'].toString()) ?? 0,
      count: int.tryParse(json['count'].toString()) ?? 0,
    );
  }
}
