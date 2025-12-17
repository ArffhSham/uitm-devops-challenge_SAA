// lib/models/property.dart

class Property {
  final String id;
  final String title;
  final String location;
  final double price;
  final String imageUrl;
  final double score;
  final bool isVerified;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.score,
    required this.isVerified,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? 'assets/placeholder.jpg',
      score: (json['score'] is num)
          ? (json['score'] as num).toDouble()
          : double.tryParse(json['score'].toString()) ?? 0.0,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}