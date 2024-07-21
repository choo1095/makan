import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/pages/results_page.dart';
import 'package:makan/provider/location_provider.dart';
import 'package:makan/provider/nearby_search_provider.dart';
import 'package:makan/provider/search_form_provider.dart';
import 'package:makan/types/nearby_places_params.dart';
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
  (id: 'american', label: 'American'),
  (id: 'bakery', label: 'Bakery'),
  (id: 'bar', label: 'Bar'),
  (id: 'barbecue', label: 'Barbecue Restaurant'),
  (id: 'brazilian', label: 'Brazilian'),
  (id: 'breakfast', label: 'Breakfast'),
  (id: 'brunch', label: 'Brunch'),
  (id: 'cafe', label: 'Cafe'),
  (id: 'chinese', label: 'Chinese'),
  (id: 'coffee', label: 'Coffee Shop'),
  (id: 'fast food', label: 'Fast Food'),
  (id: 'french', label: 'French'),
  (id: 'greek', label: 'Greek'),
  (id: 'hamburger', label: 'Hamburger'),
  (id: 'ice cream', label: 'Ice Cream'),
  (id: 'indian', label: 'Indian'),
  (id: 'indonesian', label: 'Indonesian'),
  (id: 'italian', label: 'Italian'),
  (id: 'japanese', label: 'Japanese'),
  (id: 'korean', label: 'Korean'),
  (id: 'lebanese', label: 'Lebanese'),
  (id: 'mediterranean', label: 'Mediterranean'),
  (id: 'mexican', label: 'Mexican'),
  (id: 'middle eastern', label: 'Middle Eastern'),
  (id: 'pizza', label: 'Pizza'),
  (id: 'ramen', label: 'Ramen'),
  (id: 'restaurant', label: 'Restaurant'),
  (id: 'sandwich', label: 'Sandwich Shop'),
  (id: 'seafood', label: 'Seafood'),
  (id: 'spanish', label: 'Spanish'),
  (id: 'steak', label: 'Steak House'),
  (id: 'sushi', label: 'Sushi'),
  (id: 'thai', label: 'Thai'),
  (id: 'turkish', label: 'Turkish'),
  (id: 'vegan', label: 'Vegan'),
  (id: 'vegetarian', label: 'Vegetarian'),
  (id: 'vietnamese', label: 'Vietnamese'),
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
                Consumer(builder: (context, ref, _) {
                  return ShadInputFormField(
                    id: 'location',
                    label: const Text('Location'),
                    placeholder: const Text('e.g. Uptown, Petaling Jaya'),
                    description: const Text(
                      'Your current device location will be used if this is left blank.',
                    ),
                    onChanged: (v) =>
                        ref.watch(searchFormProvider).locationSearchQuery = v,
                  );
                }),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ShadSelectFormField<String>(
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
                    ),
                    ShadSelectFormField<String>(
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
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // ShadRadioGroupFormField<String>(
                //   label: const Text('Location Type'),
                //   initialValue: LOCATION_TYPES.first.id,
                //   items: LOCATION_TYPES.map(
                //     (e) => ShadRadio(
                //       value: e.id,
                //       label: Text(e.label),
                //     ),
                //   ),
                // ),
                Text(
                  'Filter by categories (select up to 5)',
                  style: ShadTextDefaultTheme.small(family: kDefaultFontFamily)
                      .copyWith(color: Colors.black),
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
          return Container(
            padding: PAGE_PADDING,
            child: ShadButton(
              text: const Text('Submit'),
              enabled: !ref.watch(searchFormProvider).isLoading,
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
      await searchForm.fetchLatLonFromGeocoder();
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
