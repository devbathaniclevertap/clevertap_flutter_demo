import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/models/product.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final List<Product> products = [
    Product(
      id: "PRD001",
      name: "Wireless Earbuds",
      price: "2499",
      imageUrl: "https://picsum.photos/id/1/200/300",
    ),
    Product(
      id: "PRD002",
      name: "Smart Watch",
      price: "3999",
      imageUrl: "https://picsum.photos/id/2/200/300",
    ),
    Product(
      id: "PRD003",
      name: "Bluetooth Speaker",
      price: "1999",
      imageUrl: "https://picsum.photos/id/3/200/300",
    ),
    Product(
      id: "PRD004",
      name: "Power Bank",
      price: "1499",
      imageUrl: "https://picsum.photos/id/4/200/300",
    ),
    Product(
      id: "PRD005",
      name: "Noise Cancelling Headphones",
      price: "4999",
      imageUrl: "https://picsum.photos/id/5/200/300",
    ),
    Product(
      id: "PRD006",
      name: "Gaming Mouse",
      price: "2999",
      imageUrl: "https://picsum.photos/id/6/200/300",
    ),
    Product(
      id: "PRD007",
      name: "Mechanical Keyboard",
      price: "5499",
      imageUrl: "https://picsum.photos/id/7/200/300",
    ),
    Product(
      id: "PRD008",
      name: "USB-C Hub",
      price: "1999",
      imageUrl: "https://picsum.photos/id/8/200/300",
    ),
    Product(
      id: "PRD009",
      name: "Wireless Charger",
      price: "1299",
      imageUrl: "https://picsum.photos/id/9/200/300",
    ),
    Product(
      id: "PRD010",
      name: "Webcam HD",
      price: "3499",
      imageUrl: "https://picsum.photos/id/10/200/300",
    ),
  ];

  void _onProductTap(Product product) async {
    final eventData = {
      "product_id": product.id,
      "price": product.price,
      "image_url": product.imageUrl,
      "product_name": product.name,
    };

    await CleverTapPlugin.recordEvent("ProductViewed", eventData);
  }

  void _onAddToCart(Product product, BuildContext context) async {
    final eventData = {
      "product_id": product.id,
      "price": product.price,
      "image_url": product.imageUrl,
    };

    await CleverTapPlugin.recordEvent("AddToCart", eventData);
    if (context.mounted) {
      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onCharged(Product product) async {
    final eventData = {
      "product_id": product.id,
      "price": product.price,
      "image_url": product.imageUrl,
    };

    await CleverTapPlugin.recordEvent("Charged", eventData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 2,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            onTap: () => _onProductTap(product),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₹${product.price}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _onAddToCart(product, context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _onCharged(product),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
