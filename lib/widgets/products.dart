import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:ecomm_dash/widgets/customText.dart';
import 'package:ecomm_dash/models/product.dart';

class Products extends StatefulWidget {
  final List<dynamic> productList;
  final Function(Product) onTapWishlist;
  final Function(Product) onTapCard;

  const Products({
    super.key,
    required this.onTapCard,
    required this.onTapWishlist,
    required this.productList,
  });

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    _loadProductsFromJson(); // Load products from JSON file
  }

  Future<void> _loadProductsFromJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);
    setState(() {
      productList = List<Product>.from(data.map((item) => Product(
        id: item['id'],
        name: item['name'],
        price: item['price'],
        image: item['image'],
        discount: item['discount'],
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return productList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 3 : 2, // Responsive grid
            childAspectRatio: 0.65, // Adjusted for image size 430x344
            crossAxisSpacing: 15,
            mainAxisSpacing: 20,
          ),
          itemCount: productList.length,
          itemBuilder: (context, index) {
            final product = productList[index];
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product, bool isInWishlist) {
    print(product.image);
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(product.image,),fit: BoxFit.cover)
                          ),
                        ),
                        if (product.discount.isNotEmpty)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${product.discount} OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Lexend',
                      ),
                    ),
                    Text(
                      '\€${product.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'Lexend',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: isInWishlist
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                      onPressed: () {
                        widget.onTapWishlist(product);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        widget.onTapCard(product);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MyText('Add To Cart', Colors.white, 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
