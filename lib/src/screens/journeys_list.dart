import 'package:flutter/material.dart';
import 'package:navika/src/screens/journeys_details.dart';
import 'package:navika/src/screens/navigation_bar.dart';
import 'package:navika/src/style/style.dart';

import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/widgets/route/favorites.dart';

class JourneysList extends StatefulWidget {
  const JourneysList({super.key});

  @override
  State<JourneysList> createState() => _JourneysListState();
}

class _JourneysListState extends State<JourneysList> with SingleTickerProviderStateMixin {
  final String title = 'Itinéraires enregistrés';
  late TabController _tabController;
  
  List journeys = globals.hiveBox?.get('journeys');
  void update() {
    setState(() {
      journeys = globals.hiveBox?.get('journeys');
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      bottomNavigationBar: getNavigationBar(context),
      appBar: AppBar(
        title: Text(title, style: appBarTitle),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                  text: 'À venir',
                  iconMargin: EdgeInsets.only(bottom: 5, top: 5)),
              Tab(
                  text: 'Passé',
                  iconMargin: EdgeInsets.only(bottom: 5, top: 5)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    RouteFavorites(
                      journeys: getFutureJourneys(journeys),
                      update: update,
                    ),
                  ],
                ),
                ListView(
                  children: [
                    RouteFavorites(
                      journeys: getPastJourneys(journeys),
                      update: update,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
}
