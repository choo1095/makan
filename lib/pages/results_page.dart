import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:makan/provider/nearby_search_provider.dart';
import 'package:makan/widgets/common_app_bar.dart';

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

    final nearbySearch = ref.read(nearbySearchProvider);

    // get all google nearby places from api
    nearbySearch.isLoading = true;

    nearbySearch.fetchAllNearbyLocations();

    nearbySearch.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Container(
        color: Colors.red,
        height: 100,
        width: 100,
      ),
    );
  }
}
