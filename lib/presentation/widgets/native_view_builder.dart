import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NativeTaggedView extends StatelessWidget {
  final String tag;

  const NativeTaggedView({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    // Return empty SizedBox for iOS
    if (Platform.isIOS) {
      return const SizedBox.shrink();
    }

    // Show native view only for Android
    return SizedBox(
      width: 200,
      height: 20,
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
