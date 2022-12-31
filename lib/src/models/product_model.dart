// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app_miki/src/common_widgets/typedefs.dart';

class Product {
  final ProductID id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int availableQuantity;
  final double avgRating;
  final int numRatings;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.availableQuantity,
    this.avgRating = 0,
    this.numRatings = 0,
  });

  @override
  String toString() {
    return 'Product(id: $id, imageUrl: $imageUrl, title: $title, description: $description, price: $price, availableQuantity: $availableQuantity, avgRating: $avgRating, numRatings: $numRatings)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.imageUrl == imageUrl &&
      other.title == title &&
      other.description == description &&
      other.price == price &&
      other.availableQuantity == availableQuantity &&
      other.avgRating == avgRating &&
      other.numRatings == numRatings;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      imageUrl.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode ^
      availableQuantity.hashCode ^
      avgRating.hashCode ^
      numRatings.hashCode;
  }
}
