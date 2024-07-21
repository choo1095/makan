import 'package:flutter/material.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/types/google_places.dart';

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
            TextSpan(text: place.name ?? ''),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  bottom: 1,
                ),
                child: Text(
                  '\$' * (place.price_level ?? 0),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
      subtitle: Text(place.vicinity ?? ''),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            place.opening_hours?.open_now == null
                ? ''
                : place.opening_hours!.open_now!
                    ? 'OPEN'
                    : 'CLOSED',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: place.opening_hours?.open_now ?? false
                  ? Colors.green[600]
                  : Colors.red[600],
            ),
          ),
          const SizedBox(height: 2),
          if ((place.user_ratings_total ?? 0) > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14),
                const SizedBox(width: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: place.rating.toString()),
                      TextSpan(
                          text: ' (${place.user_ratings_total.toString()})',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ))
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
