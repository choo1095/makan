import 'package:flutter/material.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/widgets/common_image.dart';
import 'package:makan/widgets/search_result_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceRandomizeOneDialog extends StatelessWidget {
  final GooglePlaces? place;
  final String? image;

  const PlaceRandomizeOneDialog({
    required this.place,
    required this.image,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required GooglePlaces? place,
    required String? image,
  }) async {
    await showShadDialog(
        context: context,
        builder: (context) {
          return PlaceRandomizeOneDialog(
            place: place,
            image: image,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: const Text('Here is what you picked:'),
      content: Column(
        children: [
          CommonImage(
            image,
            width: double.infinity,
          ),
          place != null
              ? Material(child: SearchResultTile(place: place!))
              : Text(
                  '...Nothing! Please try again!',
                  style: ShadTheme.of(context).textTheme.muted,
                ),
        ],
      ),
      actions: [
        ShadButton(
          text: Text(place != null ? 'Close' : 'Ok...'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
