import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shadcn_ui/shadcn_ui.dart';

const double _kTabHeight = 46.0;

Size commonAppBarSize({PreferredSizeWidget? bottom}) {
  if (bottom != null) {
    double maxHeight = _kTabHeight;
    double indicatorWeight = 2.0;

    final double itemHeight = bottom.preferredSize.height;
    maxHeight = math.max(itemHeight, maxHeight);

    return Size.fromHeight(kToolbarHeight + maxHeight + indicatorWeight);
  }

  return const Size.fromHeight(kToolbarHeight);
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const CommonAppBar({this.title, this.bottom, this.actions, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: ShadTheme.of(context).textTheme.h4,
      ),
      automaticallyImplyLeading: true,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => commonAppBarSize(bottom: bottom);
}
