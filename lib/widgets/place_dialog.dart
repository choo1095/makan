import 'package:flutter/material.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/widgets/common_image.dart';
import 'package:makan/widgets/place_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDialog extends StatelessWidget {
  final String? dialogTitle;
  final GooglePlaces? place;
  final String? mapsUrl;
  final String? image;
  final Function()? onReroll;

  const PlaceDialog({
    this.dialogTitle,
    required this.place,
    required this.image,
    required this.mapsUrl,
    this.onReroll,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    String? dialogTitle,
    required GooglePlaces? place,
    required String? image,
    required String? mapsUrl,
    Function()? onReroll,
  }) async {
    await showShadDialog(
        context: context,
        builder: (context) {
          return PlaceDialog(
            dialogTitle: dialogTitle,
            place: place,
            image: image,
            mapsUrl: mapsUrl,
            onReroll: onReroll,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: dialogTitle != null ? Text(dialogTitle!) : null,
      content: Column(
        children: [
          CommonImage(
            image,
            width: double.infinity,
          ),
          if (place != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  child: PlaceTile(
                    place: place!,
                    showOpeningHours: true,
                  ),
                ),
                if (mapsUrl != null) ...[
                  ShadButton.secondary(
                    text: const Text('Open in Google Maps'),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse(mapsUrl!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  )
                ],
              ],
            )
          else
            Text(
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
        if (onReroll != null)
          ShadButton.outline(
            text: const Text('Pick another one!'),
            onPressed: () async {
              Navigator.of(context).pop();

              onReroll?.call();
            },
          ),
      ],
    );
  }
}
