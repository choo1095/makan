import 'package:flutter/material.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/types/google_places.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchResultTile extends StatelessWidget {
  final GooglePlaces place;

  const SearchResultTile({
    required this.place,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: PAGE_HORIZONTAL,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: place.name ?? '',
              style: ShadTheme.of(context)
                  .textTheme
                  .p
                  .copyWith(height: 1.3, fontWeight: FontWeight.w500),
            ),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  bottom: 6,
                ),
                child: Text(
                  '\$' * (place.price_level ?? 0),
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: (place.price_level ?? 0) <= 2
                            ? Colors.green[600]
                            : Colors.red[600],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        place.vicinity ?? '',
        style: ShadTheme.of(context).textTheme.muted,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
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
          const SizedBox(height: 2),
          Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
