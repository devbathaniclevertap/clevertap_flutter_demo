import 'package:flutter/material.dart';
import 'package:flutter_clevertap_demo/presentation/widgets/common_container.dart';

class CommonBoxshadowContainer extends StatelessWidget {
  const CommonBoxshadowContainer({
    super.key,
    this.height,
    this.width,
    this.child,
    this.onTap,
    this.color,
    this.shadowColor,
    this.globalKey,
  });
  final double? height;
  final double? width;
  final Widget? child;
  final Color? color;
  final GlobalKey? globalKey;
  final Color? shadowColor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return CommonContainer(
      height: height ?? 48,
      key: globalKey,
      width: width ?? MediaQuery.sizeOf(context).width,
      border: Border.all(color: Color(0xff0F1A28)),
      color: color ?? Colors.white,
      onTap: onTap,
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? Colors.black, // Shadow color
          blurRadius: 0,
          spreadRadius: 0, // Spread of the shadow
          offset: Offset(5, 5), // Position of shadow (x, y)
        ),
      ],
      child: child,
    );
  }
}
