import 'package:flutter/material.dart';

class CommonImagePlaceholder extends StatelessWidget {
  const CommonImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }
}
