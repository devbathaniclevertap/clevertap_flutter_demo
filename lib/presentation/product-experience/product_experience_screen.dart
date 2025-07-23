import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/providers/product_experience_provider.dart';
import 'package:provider/provider.dart';

class ProductExperienceScreen extends StatefulWidget {
  const ProductExperienceScreen({super.key});

  @override
  State<ProductExperienceScreen> createState() =>
      _ProductExperienceScreenState();
}

class _ProductExperienceScreenState extends State<ProductExperienceScreen> {
  // Add demo data
  final List<Map<String, String>> demoItems = [
    {
      'title': 'Electronics',
      'imageUrl': 'https://img.icons8.com/fluency/48/electronics.png',
      'key': 'icon_0'
    },
    {
      'title': 'Groceries',
      'imageUrl': 'https://img.icons8.com/fluency/48/grocery-store.png',
      'key': 'icon_1'
    },
    {
      'title': 'Fashion',
      'imageUrl': 'https://img.icons8.com/fluency/48/clothes.png',
      'key': 'icon_2'
    },
    {
      'title': 'Mobile',
      'imageUrl': 'https://img.icons8.com/fluency/48/mobile-phone.png',
      'key': 'icon_3'
    },
    {
      'title': 'Books',
      'imageUrl': 'https://img.icons8.com/fluency/48/books.png',
      'key': 'icon_4'
    },
    {
      'title': 'Sports',
      'imageUrl': 'https://img.icons8.com/fluency/48/basketball.png',
      'key': 'icon_5'
    },
  ];

  // Map to store global keys
  final Map<String, GlobalKey> itemKeys = {};

  @override
  void initState() {
    super.initState();
    // Initialize global keys for each item
    for (var item in demoItems) {
      itemKeys[item['key']!] = GlobalKey();
    }

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final provider = context.read<ProductExperienceProvider>();
      provider.setContext(context);
      provider.setTargetKeys(itemKeys); // Pass all keys at once
      // CleverTapPlugin.syncCustomTemplates();
      provider.activateCleverTapFlutterPluginHandlers();
      provider.getIconData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductExperienceProvider>(
      builder: (context, productState, _) {
        return Scaffold(
          body: Center(
            child: productState.bottomCarouselImages.isEmpty
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CarouselSlider.builder(
                      itemCount: productState.bottomCarouselImages.length,
                      itemBuilder: (context, index, realIdx) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            productState.bottomCarouselImages[index],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 120),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 120,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
