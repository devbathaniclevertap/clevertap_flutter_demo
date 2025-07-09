import 'package:clevertap_plugin/clevertap_plugin.dart';
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
          appBar: AppBar(
            title: InkWell(
              onTap: () async {
                await CleverTapPlugin.recordEvent("Nudges Event", {});
                await Future.delayed(
                  Duration(seconds: 2),
                );
                productState.activateCleverTapFlutterPluginHandlers();
                CleverTapPlugin.syncCustomTemplates();
              },
              child: const Text('Quick Links'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 5,
                childAspectRatio: 0.85,
              ),
              itemCount: demoItems.length,
              itemBuilder: (context, index) {
                final item = demoItems[index];
                return InkWell(
                  onTap: () {
                    // Handle tap with key
                    print('Tapped: ${item['key']}');
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        key: itemKeys[item['key']],
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['imageUrl']!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
