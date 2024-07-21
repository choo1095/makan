import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/pages/results_page.dart';
import 'package:makan/provider/location_provider.dart';
import 'package:makan/provider/nearby_search_provider.dart';
import 'package:makan/provider/search_form_provider.dart';
import 'package:makan/types/nearby_places_params.dart';
import 'package:makan/types/result.dart';
import 'package:makan/widgets/common_dialog.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// ignore: constant_identifier_names
const PRICE_RANGE = ['0', '1', '2', '3', '4'];

// ignore: non_constant_identifier_names
final LOCATION_TYPES = [
  (id: 'restaurant', label: 'Restaurant'),
  (id: 'bakery', label: 'Bakery'),
  (id: 'cafe', label: 'Cafe'),
  (id: 'bar', label: 'Bar'),
  (id: 'liquor_store', label: 'Liquor Store')
];

// ignore: non_constant_identifier_names
final FOOD_TYPES = [
  (id: 'american food', label: 'American'),
  (id: 'bakery', label: 'Bakery'),
  (id: 'bar', label: 'Bar'),
  (id: 'barbecue restaurant', label: 'Barbecue'),
  (id: 'brazilian food', label: 'Brazilian'),
  (id: 'bubble tea shop', label: 'Bubble Tea'),
  (id: 'cafe', label: 'Cafe'),
  (id: 'chinese food', label: 'Chinese'),
  (id: 'coffee shop', label: 'Coffee Shop'),
  (id: 'desserts', label: 'Desserts'),
  (id: 'fast food', label: 'Fast Food'),
  (id: 'french food', label: 'French'),
  (id: 'greek food', label: 'Greek'),
  (id: 'hamburger', label: 'Hamburger'),
  (id: 'ice cream', label: 'Ice Cream'),
  (id: 'indian food', label: 'Indian'),
  (id: 'indonesian food', label: 'Indonesian'),
  (id: 'italian food', label: 'Italian'),
  (id: 'japanese food', label: 'Japanese'),
  (id: 'korean food', label: 'Korean'),
  (id: 'lebanese food', label: 'Lebanese'),
  (id: 'mediterranean food', label: 'Mediterranean'),
  (id: 'mexican food', label: 'Mexican'),
  (id: 'middle eastern food', label: 'Middle Eastern'),
  (id: 'pizza', label: 'Pizza'),
  (id: 'seafood restaurant', label: 'Seafood'),
  (id: 'spanish food', label: 'Spanish'),
  (id: 'steak', label: 'Steak'),
  (id: 'thai food', label: 'Thai'),
  (id: 'turkish food', label: 'Turkish'),
  (id: 'vegetarian', label: 'Vegetarian'),
  (id: 'vietnamese food', label: 'Vietnamese'),
];

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<ShadFormState>();

  final selectedFoodTypes =
      List.generate(FOOD_TYPES.length, (_) => ValueNotifier<bool>(false));

  @override
  void dispose() {
    super.dispose();

    for (var item in selectedFoodTypes) {
      item.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: PAGE_PADDING,
          child: ShadForm(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return ShadInputFormField(
                      id: 'location',
                      label: const Text('Location'),
                      placeholder: const Text('e.g. Uptown, Petaling Jaya'),
                      description: const Text(
                        'Your current device location will be used if this is left blank.',
                      ),
                      onChanged: (v) =>
                          ref.read(searchFormProvider).locationSearchQuery = v,
                    );
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Consumer(builder: (context, ref, _) {
                      return ShadSelectFormField<String>(
                        id: 'min_price',
                        initialValue: '0',
                        label: const Text('Min. Price Range'),
                        options: PRICE_RANGE
                            .map(
                              (value) => ShadOption(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        selectedOptionBuilder: (context, value) =>
                            value == 'none' ? const Text('0') : Text(value),
                        placeholder: const Text('0'),
                        onChanged: (v) => ref
                            .read(searchFormProvider)
                            .minPrice = int.parse(v!),
                      );
                    }),
                    Consumer(
                      builder: (context, ref, _) {
                        return ShadSelectFormField<String>(
                          id: 'max_price',
                          initialValue: '4',
                          label: const Text('Max. Price Range'),
                          options: PRICE_RANGE
                              .map(
                                (value) => ShadOption(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          selectedOptionBuilder: (context, value) =>
                              value == 'none' ? const Text('4') : Text(value),
                          placeholder: const Text('4'),
                          onChanged: (v) => ref
                              .read(searchFormProvider)
                              .maxPrice = int.parse(v!),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Filter by categories (max. 5)',
                  style: ShadTheme.of(context).textTheme.small,
                ),
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final searchForm = ref.read(searchFormProvider);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: FOOD_TYPES.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        mainAxisExtent: 32,
                      ),
                      itemBuilder: (_, index) {
                        final foodType = FOOD_TYPES[index];
                        return ValueListenableBuilder<bool>(
                          valueListenable: selectedFoodTypes[index],
                          builder: (_, value, __) {
                            return ShadCheckbox(
                              value: value,
                              onChanged: (v) {
                                // if maximum food types selected, do nothing
                                if (v == true) {
                                  if (searchForm.maxFoodTypesSelected) {
                                    return;
                                  }
                                }

                                // update checkbox value
                                selectedFoodTypes[index].value = v;

                                // update selected food types
                                final foodTypes = searchForm.foodTypes;
                                if (foodTypes.contains(foodType.id)) {
                                  foodTypes.remove(foodType.id);
                                } else {
                                  foodTypes.add(foodType.id);
                                }
                                searchForm.foodTypes = foodTypes;
                              },
                              label: Text(foodType.label),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final isLoading = ref.watch(searchFormProvider).isLoading;

          return Container(
            padding: PAGE_PADDING,
            child: ShadButton(
              text: Text(!isLoading ? 'Submit' : 'Loading...'),
              enabled: !isLoading,
              onPressed: () {
                onSearchSubmit(ref);
              },
            ),
          );
        },
      ),
    );
  }

  void onSearchSubmit(WidgetRef ref) async {
    final searchForm = ref.read(searchFormProvider);
    final location = ref.read(locationProvider);
    final nearbySearch = ref.read(nearbySearchProvider);

    searchForm.isLoading = true;

    // get lat/lon
    if (searchForm.locationSearchQuery.trim().isNotEmpty) {
      final res = await searchForm.fetchLatLonFromGeocoder();

      switch (res) {
        case Success(value: final latLon):
          searchForm.location = (latLon.$1, latLon.$2);
          break;
        case Failure(errorMessage: final error):
          if (mounted) {
            CommonDialog.show(
              context,
              description: error,
              type: DialogType.error,
            );
          }
          break;
      }
    } else {
      final deviceCoordinates = await location.getLocation();
      searchForm.setLatLonFromDevice(deviceCoordinates);
    }

    searchForm.isLoading = false;

    // pass lat lon into nearby search, then search
    if (searchForm.hasLocation) {
      nearbySearch.nearbySearchParams = NearbySearchData(
        location: searchForm.location,
        foodTypes: searchForm.foodTypes,
        radius: searchForm.radius,
        minPrice: searchForm.minPrice,
        maxPrice: searchForm.maxPrice,
      );

      if (mounted) ResultsPage.goTo(context);
    } else {
      print('error!');
    }
  }
}
