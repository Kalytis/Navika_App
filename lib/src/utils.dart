import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:here_sdk/core.dart';
import 'package:navika/src/data.dart';
import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/style/style.dart';
import 'package:navika/src/extensions/hexcolor.dart';

const divider = Divider(
  color: Color(0xff808080),
  thickness: 1.5,
);

Widget loader(context) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      const CircularProgressIndicator(),
      Text('Chargement...',
        style: TextStyle( color: accentColor(context), fontWeight: FontWeight.w700),
      ),
    ],
  );
}

Widget voidData(context) {
  return Row(
    children: [
      SvgPicture.asset('assets/img/cancel.svg',
          color: accentColor(context), height: 18),
      Text(
        'Aucune information',
        style: TextStyle(
            color: accentColor(context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Segoe Ui'),
      ),
    ],
  );
}

int getMaxLength(int max, List list) {
  if (list.length > max) {
    return max;
  }
  return list.length;
}

Map getTraficLines(String name) {
  for (var lines in globals.trafic) {
    if (lines['id'] == name) {
      return lines;
    }
  }
  return {};
}

Map? getReports(String lineId) {
  return getTraficLines(LINES.getLines(lineId).id)['reports'];
}

int? getSeverity(String lineId) {
  return getTraficLines(LINES.getLines(lineId).id)['severity'];
}

String getModeImage(lineId, isDark) {
  if (LINES.isLineById(lineId)) {
    if (isDark) {
      return LINES.getLinesById(lineId).imageModeDark;
    }
    return LINES.getLinesById(lineId).imageModeLight;
  }
  if (isDark) {
    return 'assets/img/icons/bus.png';
  }
  return 'assets/img/icons/bus_light.png';
}

Color getSlug(severity, [type]) {
  if (severity == 0 && (type == null || type == 0)) {
    return Colors.transparent;
  } else if (severity == 0 && type != null && type == 1) {
    return const Color(0xff008b5b);
  } else if (severity == 5) {
    return const Color(0xffeb2031);
  } else if (severity == 4) {
    return const Color(0xfff68f53);
  } else if (severity == 3) {
    return Colors.transparent;
  } else if (severity == 2) {
    return Colors.transparent;
  } else if (severity == 1) {
    return Colors.transparent;
  } else if (type != null && type == 1) {
    return const Color(0xff008b5b);
  } else {
    return Colors.transparent;
  }
}

Color getSlugColor(severity, [type]) {
  if (severity == 0 && (type == null || type == 0)) {
    return Colors.transparent;
  } else if (severity == 0 && type != null && type == 1) {
    return const Color(0xff008b5b);
  } else if (severity == 5) {
    return const Color(0xffeb2031);
  } else if (severity == 4) {
    return const Color(0xfff68f53);
  } else if (severity == 3) {
    return const Color(0xfff68f53);
  } else if (severity == 2) {
    return const Color(0xfff68f53);
  } else if (severity == 1) {
    return const Color(0xff005bbc);
  } else if (type != null && type == 1) {
    return const Color(0xff008b5b);
  } else {
    return Colors.transparent;
  }
}

AssetImage getSlugImage(severity, [type]) {
  if (severity == 0 && (type == null || type == 0)) {
    return const AssetImage('assets/img/null.png');
  } else if (severity == 0 && type != null && type == 1) {
    return const AssetImage('assets/img/modal/valid.png');
  } else if (severity == 5) {
    return const AssetImage('assets/img/modal/error.png');
  } else if (severity == 4) {
    return const AssetImage('assets/img/modal/warning.png');
  } else if (severity == 3) {
    return const AssetImage('assets/img/modal/work.png');
  } else if (severity == 2) {
    return const AssetImage('assets/img/modal/futur_work.png');
  } else if (severity == 1) {
    return const AssetImage('assets/img/modal/information.png');
  } else if (type != null && type == 1) {
    return const AssetImage('assets/img/modal/valid.png');
  } else {
    return const AssetImage('assets/img/null.png');
    // return const AssetImage('assets/img/modal/interogation_grey.png');
  }
}

String getSlugTitle(severity) {
  if (severity == 0) {
    return 'Trafic fluide';
  } else if (severity == 5) {
    return 'Trafic fortement perturbé';
  } else if (severity == 4) {
    return 'Trafic perturbé';
  } else if (severity == 3) {
    return 'Travaux';
  } else if (severity == 2) {
    return 'Travaux à venir';
  } else if (severity == 1) {
    return 'Information';
  } else {
    return 'Trafic fluide';
    //return "Unknown";
  }
}

String getDateTime(String time) {
  DateTime dttime = DateTime.parse(time);

  String dtday = dttime.day < 10 ? '0${dttime.day}' : dttime.day.toString();
  String dtmonth =
      dttime.month < 10 ? '0${dttime.month}' : dttime.month.toString();
  String dtyear = dttime.year.toString();
  String dthour = dttime.hour < 10 ? '0${dttime.hour}' : dttime.hour.toString();
  String dtminute =
      dttime.minute < 10 ? '0${dttime.minute}' : dttime.minute.toString();

  return '$dtday/$dtmonth/$dtyear $dthour:$dtminute';
}

List clearTrain(List departures) {
  bool hide = globals.hiveBox?.get('hideTerminusTrain') ?? false;

  if (hide){
    List list = [];
    for (var departure in departures){
      if (departure['informations']['message'] != 'terminus'){
        list.add(departure);
      }
    }
    return list;
  } 

  return departures;
}

// Schedules

int getTimeDifference(String time) {
  DateTime dttime = DateTime.parse(time);
  DateTime dtnow = DateTime.now();

  Duration diff = dttime.difference(dtnow);

  return diff.inMinutes;
}

String getTime(String time) {
  if (time == '') {
    return '';
  }

  DateTime dttime = DateTime.parse(time);

  var now = DateTime.now();
  var timezoneOffsetInMinutes = now.timeZoneOffset.inMinutes;
  dttime = dttime.add(Duration(minutes: timezoneOffsetInMinutes));

  String dthour = dttime.hour < 10 ? '0${dttime.hour}' : dttime.hour.toString();
  String dtminute = dttime.minute < 10 ? '0${dttime.minute}' : dttime.minute.toString();

  return '$dthour:$dtminute';
}

String makeTime(String time) {
  if (time == '') {
    return '';
  }
  return '${time.substring(0, 2)}:${time.substring(2, 4)}';
}


List getState(Map train) {
  String state = train['stop_date_time']['state'];

  List res = [];
  if (state == 'modified') {
    res.add('modified');
  }
  if (state != 'ontime' && state != 'theorical') {
    res.add(state);
  }
  if (getLate(train) > 0) {
    res.add('delayed');
  }
  //else {
  if (res.isEmpty) {
    res.add('ontime');
  }
  return res;
}

int getLate(Map train) {
  String departure = train['stop_date_time']['departure_date_time'];
  String expectedDeparture = train['stop_date_time']['base_departure_date_time'];
  
  if (departure == '' || expectedDeparture == '') {
    return 0;
  }
  DateTime dttime = DateTime.parse(departure);
  DateTime dtexpe = DateTime.parse(expectedDeparture);
  Duration diff = dttime.difference(dtexpe);
  return diff.inMinutes;
}

Color getColorByState(state, context) {
  if (state.contains('cancelled')) {
    return const Color(0xffeb2031);
  } else if (state.contains('delayed') || state.contains('modified')) {
    return const Color(0xfff68f53);
  } else if (state.contains('ontime')) {
    return Colors.white.withOpacity(0);
  } else {
    return const Color(0xffa9a9a9);
  }
}

Color getSchedulesColorByState(state, context) {
  switch (state) {
    case 'cancelled':
      return const Color(0xffeb2031);
    case 'delayed':
      return const Color(0xfff68f53);
    case 'ontime':
      return Theme.of(context).colorScheme.primary;
    default:
      return const Color(0xffa9a9a9);
  }
}

Color getDeparturesColorByState(state, context) {
  if (state.contains('cancelled') ||
      state.contains('delayed') ||
      state.contains('modified') ||
      state.contains('ontime')) {
    return const Color(0xfffcc900);
  }

  return const Color(0xffa9a9a9);
}

Color getColorForDirectionByState(state, context) {
  if (state.contains('cancelled')) {
    return const Color(0xffeb2031);
  } else if (state.contains('cancelled')) {
    return const Color(0xffeb2031);
  } else if (state.contains('modified')) {
    return const Color(0xfff68f53);
  } else {
    return accentColor(context);
  }
}

Color getBackColorByState(state, context) {
  if (state.contains('cancelled')) {
    return const Color(0xffeb2031);
  } else if (state.contains('delayed') || state.contains('modified')) {
    return const Color(0xfff68f53);
  } else {
    return Colors.white.withOpacity(0);
  }
}

// Journeys

Color getColorByType(section) {
  if (section['type'] == 'street_network' || section['type'] == 'waiting') {
    return const Color(0xff7b7b7b);
  }
  if (section['informations'] != null &&
      section['informations']['line']['color'] != null) {
    return HexColor.fromHex(section['informations']['line']['color']);
  }
  return const Color(0xff202020);
}

double getLineWidthByType(String type) {
  if (type == 'public_transport') {
    return 20;
  }
  return 7;
}

double degTorad(double x) {
  return pi * x / 180;
}

double getDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6378137; // Terre = sphère de 6378km de rayon
  double rlo1 = degTorad(lon1); // CONVERSION
  double rla1 = degTorad(lat1);
  double rlo2 = degTorad(lon2);
  double rla2 = degTorad(lat2);
  double dlo = (rlo2 - rlo1) / 2;
  double dla = (rla2 - rla1) / 2;
  double a =
      (sin(dla) * sin(dla)) + sin(rla1) * cos(rla2) * (sin(dlo) * sin(dlo));
  double d = 2 * atan2(sqrt(a), sqrt(1 - a));
  return ((earthRadius * d) * 3);
}

GeoCoordinates getCenterPoint(
  double lat1, double lon1, double lat2, double lon2) {
  double clon = (lon1 + lon2) / 2;
  double clat = (lat1 + lat2) / 2;

  return GeoCoordinates(clat, clon);
}

String getStringTime(String time) {
  DateTime dttime = DateTime.parse(time);
  String dthour = dttime.hour < 10 ? '0${dttime.hour}' : dttime.hour.toString();
  String dtminute =
      dttime.minute < 10 ? '0${dttime.minute}' : dttime.minute.toString();
  return '$dthour:$dtminute';
}

TextStyle getTextStyle(context, int size) {
  return TextStyle(
    fontSize: size.toDouble(),
    fontWeight: FontWeight.w600,
    fontFamily: 'Segoe Ui',
    color: accentColor(context),
  );
}

String getDuration(int d) {
  Duration duration = Duration(seconds: d);
  String res = '';
  if (duration.inMinutes >= 60) {
    res = '$res${duration.inHours.toString()}h${duration.inMinutes.remainder(60).toString()}';
  } else {
    res = '$res${duration.inMinutes.remainder(60).toString()} mn';
  }

  return res;
}

String getDistanceText(int d) {
  // get the distance in meters or kilometers
  String res = '';
  // ${d}
  if (d >= 1000) {
    res = '$res${d / 1000.0} km';
  } else {
    res = '$res$d m';
  }
  return res;
}

List<Widget> getDurationWidget(int d, context) {
  Duration duration = Duration(seconds: d);
  List<Widget> res = [];

  if (duration.inMinutes >= 60) {
    res.add(
        Text(duration.inHours.toString(), style: getTextStyle(context, 24)));

    res.add(Text('h', style: getTextStyle(context, 10)));

    res.add(Text(
        duration.inMinutes.remainder(60) < 10
            ? '0${duration.inMinutes.remainder(60).toString()}'
            : duration.inMinutes.remainder(60).toString(),
        style: getTextStyle(context, 24)));
  } else {
    res.add(Text(duration.inMinutes.remainder(60).toString(),
        style: getTextStyle(context, 24)));

    res.add(Text('mn', style: getTextStyle(context, 10)));
  }

  return res;
}