import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum DialogType { error, success }

class CommonDialog extends StatelessWidget {
  final String? title;
  final String description;
  final DialogType type;

  const CommonDialog(
      {required this.description, required this.type, this.title, super.key});

  static Future<void> show(
    BuildContext context, {
    required String description,
    required DialogType type,
    String? title,
  }) async {
    await showShadDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          description: description,
          type: type,
          title: title,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: Text(title ?? (type == DialogType.success ? 'Success' : 'Error')),
      description: Text(description),
      actions: [
        ShadButton(
          text: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
