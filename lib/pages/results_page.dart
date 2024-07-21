import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/provider/nearby_search_provider.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/widgets/common_app_bar.dart';
import 'package:makan/widgets/place_randomize_one_dialog.dart';
import 'package:makan/widgets/search_result_tile.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResultsPage extends ConsumerStatefulWidget {
  static Future<void> goTo(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultsPage(),
      ),
    );
  }

  const ResultsPage({super.key});

  @override
  ConsumerState<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final nearbySearch = ref.watch(nearbySearchProvider);

    return nearbySearch.isLoading
        ? Scaffold(
            body: Center(
              child: Text(
                'Loading... Please wait',
                style: ShadTheme.of(context).textTheme.muted,
              ),
            ),
          )
        : nearbySearch.nearbySearchResults.length > 1
            ? multipleCategoryView()
            : singleCategoryView();
  }

  Widget multipleCategoryView() {
    final nearbySearch = ref.read(nearbySearchProvider);

    return DefaultTabController(
      length: nearbySearch.nearbySearchResults.length,
      child: Scaffold(
        appBar: appBar(
          nearbySearch,
          showTabBar: true,
        ),
        body: TabBarView(
          children: [
            for (var item in nearbySearch.nearbySearchResults)
              resultsListView(nearbySearch, item),
          ],
        ),
        // body: Container(color: Colors.red),
      ),
    );
  }

  PreferredSizeWidget appBar(
    NearbySearchProvider nearbySearch, {
    required bool showTabBar,
  }) {
    final nearbySearch = ref.read(nearbySearchProvider);

    return CommonAppBar(
      title: 'Search Results',
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: ShadButton(
            text: const Text('Pick one!'),
            onPressed: () => showOneRandomPlaceDialog(context, nearbySearch),
          ),
        ),
      ],
      bottom: showTabBar
          ? TabBar(
              tabs: [
                for (String item
                    in nearbySearch.nearbySearchParams?.foodTypes ?? [])
                  Tab(
                    child: Text(
                      item.toUpperCase().substring(0, 1) + item.substring(1),
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    // text:
                  ),
              ],
            )
          : null,
    );
  }

  Widget singleCategoryView() {
    final nearbySearch = ref.read(nearbySearchProvider);

    return Scaffold(
      appBar: appBar(
        nearbySearch,
        showTabBar: false,
      ),
      body: resultsListView(
          nearbySearch, nearbySearch.nearbySearchResults.firstOrNull ?? []),
    );
  }

  Widget resultsListView(
      NearbySearchProvider nearbySearch, List<GooglePlaces> results) {
    if (nearbySearch.error != null) {
      return Padding(
        padding: PAGE_PADDING,
        child: Text(
          nearbySearch.error ?? 'Error!',
          style: ShadTheme.of(context).textTheme.muted,
        ),
      );
    }

    return results.isNotEmpty
        ? ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final place = results[index];
              return SearchResultTile(place: place);
            },
          )
        : Padding(
            padding: PAGE_PADDING,
            child: Text(
              nearbySearch.error ?? 'Error!',
              style: ShadTheme.of(context).textTheme.muted,
            ),
          );
  }

  void showOneRandomPlaceDialog(
    BuildContext context,
    NearbySearchProvider nearbySearch,
  ) async {
    final randomizedPlace = nearbySearch.getOneRandomPlace();
    final image = nearbySearch
        .getPlaceImage(randomizedPlace?.photos?.firstOrNull?.photo_reference);

    if (context.mounted) {
      PlaceRandomizeOneDialog.show(
        context,
        place: randomizedPlace,
        image: image,
      );
    }
  }

  void fetchData() async {
    final nearbySearch = ref.read(nearbySearchProvider);

    // get all google nearby places from api
    nearbySearch.isLoading = true;

    await nearbySearch.fetchAllNearbyLocations();

    nearbySearch.isLoading = false;
  }
}
