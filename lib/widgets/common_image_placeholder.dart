import 'package:flutter/material.dart';

class CommonImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const CommonImagePlaceholder(
      {this.width, this.height, this.borderRadius, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        color: Colors.grey[100],
      ),
      alignment: Alignment.center,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey[200]!.withOpacity(0.5),
            width: 1.5,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
