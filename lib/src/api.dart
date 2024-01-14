import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:http/http.dart' as http;
import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/data/app.dart' as app;
import 'package:location/location.dart' as gps;
import 'package:navika/src/utils.dart';

enum ApiStatus {
  ok,
  socketException,
  timeoutException,
  serverException,
  unknownException
}

class NavikaApi {
  Future<bool> getIsGPSallowed() async {
    return await globals.hiveBox.get('allowGps');
  }

  String buildUrl(String baseUrl, Map<String, dynamic> params) {
    List<String> query = [];

    params.forEach((key, value) {
      // Si on passe une liste
      if (value is List) {
        for (var element in value) {
          String encodedElement = Uri.encodeComponent(element.toString());

          query.add('$key[]=$encodedElement');
        }
      } else {
        String encodedValue = Uri.encodeComponent(value.toString());

        query.add('$key=$encodedValue');
      }
    });
    String uri = query.join('&');
    String url = '$baseUrl?$uri';

    return url;
  }

  Future doRequest(String url) async {
    Map result = {
      'value': null,
      'status': ApiStatus.ok,
    };

    if (kDebugMode) {
      print({'INFO_request', url});
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        result['value'] = data;
      } else {
        result['status'] = ApiStatus.serverException;
      }
    } on SocketException {
      result['status'] = ApiStatus.socketException;
    } on TimeoutException {
      result['status'] = ApiStatus.timeoutException;
    } catch (e) {
      result['status'] = ApiStatus.unknownException;
    }
    if (kDebugMode) {
      print({'INFO_response', result['status']});
    }
    return result;
  }

  Future doPost(String url, Object body) async {
    Map result = {
      'value': null,
      'status': ApiStatus.ok,
    };

    if (kDebugMode) {
      print({'INFO_request', url});
    }

    try {
      final response = await http.post(
        Uri.parse(url), 
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        result['value'] = data;
      } else {
        result['status'] = ApiStatus.serverException;
      }
    } on SocketException {
      result['status'] = ApiStatus.socketException;
    } on TimeoutException {
      result['status'] = ApiStatus.timeoutException;
    } catch (e) {
      result['status'] = ApiStatus.unknownException;
    }
    if (kDebugMode) {
      print({'INFO_response', result['status']});
    }
    return result;
  }

  Future getIndex() async {
    String url = buildUrl(globals.API_INDEX, {'v': app.version});

    return doRequest(url);
  }

  Future getPlaces( String query, gps.LocationData? locationData, int? flag) async {
    String url = '';

    bool isGPSallowed = await getIsGPSallowed();

    flag ??= 0;

    if (isGPSallowed &&
        (locationData?.latitude != null || locationData?.longitude != null) &&
        query != '') {
      url = buildUrl(globals.API_PLACES, {
        'lat': locationData?.latitude,
        'lon': locationData?.longitude,
        'q': query,
        'flag': flag,
      });
    } else if (query != '') {
      url = buildUrl(globals.API_PLACES, {
        'q': query,
        'flag': flag,
      });
    } else if (isGPSallowed &&
        (locationData?.latitude != null || locationData?.longitude != null)) {
      url = buildUrl(globals.API_PLACES, {
        'lat': locationData?.latitude,
        'lon': locationData?.longitude,
        'flag': flag,
      });
    } else {
      url = buildUrl(globals.API_PLACES, {
        'q': '',
        'flag': flag,
      });
    }

    return doRequest(url);
  }

  Future getStops(
    String query, gps.LocationData? locationData, int? flag) async {
    String url = '';

    bool isGPSallowed = await getIsGPSallowed();

    flag ??= 0;

    if (isGPSallowed &&
        (locationData?.latitude != null || locationData?.longitude != null) &&
        query != '') {
      url = buildUrl(globals.API_STOPS, {
        'lat': locationData?.latitude,
        'lon': locationData?.longitude,
        'q': query,
        'flag': flag,
      });
    } else if (query != '') {
      url = buildUrl(globals.API_STOPS, {
        'q': query,
        'flag': flag,
      });
    } else if (isGPSallowed &&
        (locationData?.latitude != null || locationData?.longitude != null)) {
      url = buildUrl(globals.API_STOPS, {
        'lat': locationData?.latitude,
        'lon': locationData?.longitude,
        'flag': flag,
      });
    } else {
      url = buildUrl(globals.API_STOPS, {
        'q': '',
        'flag': flag,
      });
    }

    return doRequest(url);
  }

  Future getNearPoints(double zoom, GeoCoordinates coords) async {
    String url = buildUrl(globals.API_NEAR, {
      'lat': coords.latitude,
      'lon': coords.longitude,
      'z': zoom,
    });

    return doRequest(url);
  }

  Future getLines(String q, int? flag) async {
    String url = buildUrl(globals.API_LINES, {
      'q': q,
      'flag': flag,
    });

    return doRequest(url);
  }

  Future getLine(String id) async {
    String url = buildUrl('${globals.API_LINES}/$id', {});

    return doRequest(url);
  }

  Future getLineSchedules(String id, String stopId, DateTime datetime) async {
    String url = buildUrl('${globals.API_LINES}/$id/schedules/$stopId', {
      'date': datetime.toIso8601String().substring(0, 10),
    });

    return doRequest(url);
  }

  Future getJourneys(String from, String to, DateTime datetime, String travelerType, String timeType, List id, List modes) async {
    String url = buildUrl(globals.API_JOURNEYS, {
      'from': from,
      'to': to,
      timeType: datetime.toIso8601String(),
      'traveler_type': travelerType,
      'forbidden_id' : id,
      'forbidden_mode' : modes
    });
    return doRequest(url);
  }

  Future getJourneyById(String id) async {
    String url = buildUrl('${globals.API_JOURNEY}/$id', {});
    return doRequest(url);
  }

  Future getBikeStations(String id) async {
    String url = buildUrl('${globals.API_BIKE_STATIONS}/$id', {});

    return doRequest(url);
  }

  Future getSchedules(String id, bool ungroup) async {
    String url = buildUrl('${globals.API_SCHEDULES}/$id',
        {'ungroupDepartures': ungroup.toString()});

    return doRequest(url);
  }

  Future getSchedulesLines(String id, String line) async {
    String url = buildUrl('${globals.API_SCHEDULES}/$id', {'l': line});

    return doRequest(url);
  }

  Future getTrafic(List? lines) async {
    String url = buildUrl(globals.API_TRAFIC, {'lines': lines});

    return doRequest(url);
  }

  Future getVehicleJourney(String id) async {
    String url = buildUrl('${globals.API_VEHICLE_JOURNEY}/$id', {});

    return doRequest(url);
  }

  Future getMaps() async {
    String url = buildUrl(globals.API_MAPS, {});

    return doRequest(url);
  }

  Future addNotificationSubscription(String line, String type, Map days, TimeOfDay startTime, TimeOfDay endTime) async {
    String url = buildUrl(globals.API_ADD_NOTIFICATION_SUBSCRIPTION, {});
    Object body = {
      'token' : globals.fcmToken,
      'line' : line,
      'type' : type,
      'days' : json.encode(days),
      'start_time' : timeToString(startTime),
      'end_time' : timeToString(endTime),
    };

    return doPost(url, body);
  }

  Future renewNotificationToken(String oldToken, String newToken) async {
    String url = buildUrl(globals.API_RENEW_NOTIFICATION, {});
    Object body = {
      'old_token' : oldToken,
      'new_token' : newToken,
    };

    return doPost(url, body);
  }

  Future getNotificationSubscription(String id) async {
    String url = buildUrl('${globals.API_GET_NOTIFICATION_SUBSCRIPTION}/$id', {});

    return doRequest(url);
  }

  Future removeNotificationSubscription(String id) async {
    String url = buildUrl('${globals.API_REMOVE_NOTIFICATION_SUBSCRIPTION}/$id', {});

    return doRequest(url);
  }
}
