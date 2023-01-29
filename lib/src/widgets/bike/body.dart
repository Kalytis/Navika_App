import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/style/style.dart';

class BikeBody extends StatefulWidget {
  final ScrollController scrollController;

  const BikeBody({required this.scrollController, super.key});

  @override
  State<BikeBody> createState() => _BikeBodyState();
}

class _BikeBodyState extends State<BikeBody>
    with SingleTickerProviderStateMixin {
  String name = globals.schedulesStopName;
  String id = globals.schedulesStopArea;

  Map bikeStation = {};
  late Timer _update;
  String error = '';

  @override
  void initState() {
    super.initState();
    checkUpdates();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getSchedules();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _update.cancel();
  }

  Future<void> _getSchedules() async {
    if (kDebugMode) {
      print({'INFO_', globals.schedulesStopArea});
    }
    try {
      if (mounted) {
        final response = await http.get(Uri.parse(
            '${globals.API_BIKE_STATIONS}?s=${globals.schedulesStopArea}'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          print({'INFO_', data});

          if (mounted) {
            setState(() {
              if (data['station'] != null) {
                bikeStation = data['station'];
              }
              error = '';
            });
          }
        } else {
          setState(() {
            error = 'Récupération des informations impossible.';
          });
        }
      }
    } on Exception catch (_) {
      setState(() {
        error = "Une erreur s'est produite.";
      });
    }
  }

  void checkUpdates() {
    _update = Timer(const Duration(milliseconds: 100), () {
      checkUpdates();
      if (id != globals.schedulesStopArea) {
        setState(() {
          id = globals.schedulesStopArea;
          bikeStation = {};
        });
        _getSchedules();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const SizedBox(height: 200),
        if (bikeStation.isEmpty)
          Column(children: [
            const CircularProgressIndicator(),
            Text(
              'Chargement...',
              style: TextStyle(
                  color: accentColor(context), fontWeight: FontWeight.w700),
            ),
          ])
        else
          Container(
            padding: const EdgeInsets.only(
                left: 20.0, top: 30.0, right: 20.0, bottom: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Vélo mécanique',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Segoe Ui',
                        ),
                      ),
                    ),
                    Text(bikeStation['mechanical'].toString()),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Vélo électriques',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Segoe Ui',
                        ),
                      ),
                    ),
                    Text(bikeStation['ebike'].toString()),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Places disponibles',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Segoe Ui',
                        ),
                      ),
                    ),
                    Text(bikeStation['capacity'].toString()),
                  ],
                ),
              ],
            ),
          )
      ],);
}
