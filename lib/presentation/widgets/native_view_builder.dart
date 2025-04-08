import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NativeTaggedView extends StatelessWidget {
  final String tag;

  const NativeTaggedView({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Increased size for better hit testing
      height: 20, // Increased size for better hit testing
      child: Center(
        child: AndroidView(
          viewType: 'tagged_view',
          layoutDirection: TextDirection.ltr,
          creationParams: {"tag": tag},
          creationParamsCodec: const StandardMessageCodec(),
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        ),
      ),
    );
  }
}
