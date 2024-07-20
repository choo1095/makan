import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/constants/spacing.dart';
import 'package:makan/provider/nearby_search_provider.dart';
import 'package:makan/types/google_places.dart';
import 'package:makan/widgets/common_app_bar.dart';
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
        ? const Scaffold(
            body: Center(
              child: Text('Loading... Please wait'),
            ),
          )
        : nearbySearch.nearbySearchResults.length > 1
            ? multipleCategoryView(nearbySearch)
            : singleCategoryView(nearbySearch);
  }

  Widget multipleCategoryView(NearbySearchProvider nearbySearch) {
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
              resultsListView(item),
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
    return CommonAppBar(
      title: 'Search Results',
      actions: [
        ShadButton.ghost(
          text: const Text('Pick one!'),
          onPressed: () => showOneRandomPlaceDialog(context, nearbySearch),
        ),
      ],
      bottom: showTabBar
          ? TabBar(
              tabs: [
                for (var item
                    in nearbySearch.nearbySearchParams?.foodTypes ?? [])
                  Tab(
                    text: item,
                  ),
              ],
            )
          : null,
    );
  }

  Widget singleCategoryView(NearbySearchProvider nearbySearch) {
    return Scaffold(
        appBar: appBar(
          nearbySearch,
          showTabBar: false,
        ),
        body: nearbySearch.nearbySearchResults.isNotEmpty
            ? resultsListView(nearbySearch.nearbySearchResults.first)
            : const SizedBox());
  }

  Widget resultsListView(List<GooglePlaces> results) {
    return results.isNotEmpty
        ? ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final place = results[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: PAGE_HORIZONTAL,
                ),
                title: Text(place.name ?? ''),
                subtitle: Text(place.vicinity ?? ''),
              );
            },
          )
        : const Center(child: Text('No results found'));
  }

  void showOneRandomPlaceDialog(
    BuildContext context,
    NearbySearchProvider nearbySearch,
  ) {
    final randomizedPlace = nearbySearch.getOneRandomPlace();

    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Here is what you picked:'),
        description: Text(randomizedPlace?.name ?? 'Nothing. Try again!'),
        actions: [
          ShadButton(
            text: const Text('Ok...'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void fetchData() async {
    final nearbySearch = ref.read(nearbySearchProvider);

    // get all google nearby places from api
    nearbySearch.isLoading = true;

    await nearbySearch.fetchAllNearbyLocations();

    nearbySearch.isLoading = false;
  }
}
