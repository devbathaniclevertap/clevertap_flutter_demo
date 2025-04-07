import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeTaggedView extends StatelessWidget {
  final String tag;

  const NativeTaggedView({super.key, required this.tag});

  final String viewType = 'tagged_view';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, // Increased size
      height: 20, // Increased size
      child: AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: {"tag": tag},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
