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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      context.read<ProductExperienceProvider>().getIconData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductExperienceProvider>(
      builder: (context, productState, _) {
        final quickLinks =
            productState.productIconEntity?.iconData.quickLinks ?? [];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Quick Links'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: quickLinks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: quickLinks.length,
                    itemBuilder: (context, index) {
                      final item = quickLinks[index];
                      return InkWell(
                        onTap: () {
                          productState.onButtonClick(item);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 48),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
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
