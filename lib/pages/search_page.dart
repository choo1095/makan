import 'package:flutter/material.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/widgets/common_app_bar.dart';
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
  (id: 'american_restaurant', label: 'American'),
  (id: 'bakery', label: 'Bakery'),
  (id: 'bar', label: 'Bar'),
  (id: 'barbecue_restaurant', label: 'Barbecue Restaurant'),
  (id: 'brazilian_restaurant', label: 'Brazilian'),
  (id: 'breakfast_restaurant', label: 'Breakfast'),
  (id: 'brunch_restaurant', label: 'Brunch'),
  (id: 'cafe', label: 'Cafe'),
  (id: 'chinese_restaurant', label: 'Chinese'),
  (id: 'coffee_shop', label: 'Coffee Shop'),
  (id: 'fast_food_restaurant', label: 'Fast Food'),
  (id: 'french_restaurant', label: 'French'),
  (id: 'greek_restaurant', label: 'Greek'),
  (id: 'hamburger_restaurant', label: 'Hamburger'),
  (id: 'ice_cream_shop', label: 'Ice Cream'),
  (id: 'indian_restaurant', label: 'Indian'),
  (id: 'indonesian_restaurant', label: 'Indonesian'),
  (id: 'italian_restaurant', label: 'Italian'),
  (id: 'japanese_restaurant', label: 'Japanese'),
  (id: 'korean_restaurant', label: 'Korean'),
  (id: 'lebanese_restaurant', label: 'Lebanese'),
  (id: 'meal_delivery', label: 'Meal Delivery'),
  (id: 'meal_takeaway', label: 'Meal Takeaway'),
  (id: 'mediterranean_restaurant', label: 'Mediterranean'),
  (id: 'mexican_restaurant', label: 'Mexican'),
  (id: 'middle_eastern_restaurant', label: 'Middle Eastern'),
  (id: 'pizza_restaurant', label: 'Pizza'),
  (id: 'ramen_restaurant', label: 'Ramen'),
  (id: 'restaurant', label: 'Restaurant'),
  (id: 'sandwich_shop', label: 'Sandwich Shop'),
  (id: 'seafood_restaurant', label: 'Seafood'),
  (id: 'spanish_restaurant', label: 'Spanish'),
  (id: 'steak_house', label: 'Steak House'),
  (id: 'sushi_restaurant', label: 'Sushi'),
  (id: 'thai_restaurant', label: 'Thai'),
  (id: 'turkish_restaurant', label: 'Turkish'),
  (id: 'vegan_restaurant', label: 'Vegan'),
  (id: 'vegetarian_restaurant', label: 'Vegetarian'),
  (id: 'vietnamese_restaurant', label: 'Vietnamese'),
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
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        padding: PAGE_PADDING,
        child: ShadForm(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'location',
                label: const Text('Location'),
                placeholder: const Text('e.g. Uptown'),
              ),
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
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: FOOD_TYPES.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onChanged: (v) => selectedFoodTypes[index].value = v,
                        label: Text(foodType.label),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: PAGE_PADDING,
        child: ShadButton(
          text: const Text('Submit'),
          onPressed: () {
            if (formKey.currentState!.saveAndValidate()) {
              print('validation succeeded with ${formKey.currentState!.value}');
            } else {
              print('validation failed');
            }
          },
        ),
      ),
    );
  }
}
