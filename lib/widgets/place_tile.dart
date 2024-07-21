import 'package:flutter/material.dart';
import 'package:makan/types/google_places.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceTile extends StatelessWidget {
  final GooglePlaces place;
  final bool showOpeningHours;
  final EdgeInsets padding;
  final Function()? onTap;

  const PlaceTile({
    required this.place,
    required this.showOpeningHours,
    this.padding = EdgeInsets.zero,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: padding,
      title: Text(
        place.name ?? '',
        style: ShadTheme.of(context)
            .textTheme
            .p
            .copyWith(height: 1.3, fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.vicinity ?? '',
            style: ShadTheme.of(context).textTheme.muted,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 14),
              const SizedBox(width: 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: (place.rating ?? 0).toString(),
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            fontSize: 12,
                          ),
                    ),
                    TextSpan(
                      text: ' (${place.user_ratings_total ?? 0.toString()})',
                      style: ShadTheme.of(context).textTheme.muted.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              if (place.price_level != null)
                Text(
                  '  —  ${'\$' * (place.price_level ?? 0)}',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontSize: 12,
                      ),
                ),
            ],
          ),
        ],
      ),
      trailing: showOpeningHours
          ? Container(
              height: double.infinity,
              padding: const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                place.opening_hours?.open_now == null
                    ? ''
                    : place.opening_hours!.open_now!
                        ? 'OPEN'
                        : 'CLOSED',
                style: ShadTheme.of(context).textTheme.small.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: place.opening_hours?.open_now ?? false
                          ? Colors.green[600]
                          : Colors.red[600],
                    ),
              ),
            )
          : null,
    );
  }
}
