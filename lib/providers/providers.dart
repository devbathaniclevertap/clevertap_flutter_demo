import 'package:flutter_clevertap_demo/providers/home_provider.dart';
import 'package:flutter_clevertap_demo/providers/product_experience_provider.dart';
import 'package:provider/provider.dart';

final providers = [
  ChangeNotifierProvider<HomeProvider>(
    create: (context) => HomeProvider(),
    lazy: false,
  ),
  ChangeNotifierProvider<ProductExperienceProvider>(
    create: (context) => ProductExperienceProvider(),
    lazy: false,
  ),
];
