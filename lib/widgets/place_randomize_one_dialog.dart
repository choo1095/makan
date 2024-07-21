import 'package:flutter/material.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/widgets/common_image_placeholder.dart';
import 'package:makan/widgets/search_result_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceRandomizeOneDialog extends StatelessWidget {
  final GooglePlaces? place;

  const PlaceRandomizeOneDialog({
    required this.place,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required GooglePlaces? place,
  }) async {
    await showShadDialog(
        context: context,
        builder: (context) {
          return PlaceRandomizeOneDialog(
            place: place,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: const Text('Here is what you picked:'),
      content: Column(children: [
        CommonImagePlaceholder(),
        place != null
            ? Material(child: SearchResultTile(place: place!))
            : Text(
                '...Nothing! Please try again!',
                style: ShadTheme.of(context).textTheme.muted,
              ),
      ]),
      actions: [
        ShadButton(
          text: Text(place != null ? 'Ok!' : 'Ok...'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
