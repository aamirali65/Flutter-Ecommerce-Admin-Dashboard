class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String discount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      discount: json['discount'],
    );
  }

  // Override the equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product && runtimeType == other.runtimeType && id == other.id;

  // Override the hashCode
  @override
  int get hashCode => id.hashCode;

  // Method to convert a Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'discount': discount,
    };
  }
}
