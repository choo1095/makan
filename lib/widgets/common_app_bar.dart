import 'package:flutter/material.dart';
import 'dart:math' as math;

const double _kTabHeight = 46.0;

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const CommonAppBar({this.title, this.bottom, this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      automaticallyImplyLeading: true,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    if (bottom != null && bottom is PreferredSizeWidget) {
      double maxHeight = _kTabHeight;
      double indicatorWeight = 2.0;

      final double itemHeight = bottom!.preferredSize.height;
      maxHeight = math.max(itemHeight, maxHeight);

      return Size.fromHeight(kToolbarHeight + maxHeight + indicatorWeight);
    }

    return const Size.fromHeight(kToolbarHeight);
  }
}
