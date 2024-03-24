import 'package:flutter/material.dart';

import 'package:navika/src/data/lines.dart';
import 'package:navika/src/extensions/datetime.dart';
import 'package:navika/src/extensions/string.dart';
import 'package:navika/src/icons/navika_icons_icons.dart';
import 'package:navika/src/screens/journeys.dart';
import 'package:navika/src/screens/navigation_bar.dart';
import 'package:navika/src/style.dart';
import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/utils.dart';
import 'package:navika/src/widgets/trafic_details/disruptions.dart';

Map shortDay = {
  1: 'Lun',
  2: 'Mar',
  3: 'Mer',
  4: 'Jeu',
  5: 'Ven',
  6: 'Sam',
  7: 'Dim',
};

Widget buildDay(context, DateTime date, DateTime selectedDate, Function setSelectedDate, int index, List reports) {

  DateTime currentDate = DateTime.now();
  DateTime dt = DateTime(date.year, date.month, index); 

  return Expanded(
    child: InkWell(
      onTap: () => setSelectedDate(dt),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 45,
        decoration: BoxDecoration(
          color: dt.isSameDate(selectedDate)
            ? Theme.of(context).colorScheme.primary
            : const Color(0x00000000),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: hasWork(dt, reports)
            ? Border(
                bottom: BorderSide(
                  width: 3.0,
                  color: getSlug(globals.lineTrafic['severity'] ?? 0, true),
                )
              )
            : null
            
          ),
          child: Center(
            child: Text('$index',
              style: TextStyle(
                color: dt.isSameDate(selectedDate)
                  ? const Color(0xffffffff)
                  : Theme.of(context).colorScheme.onSurface,
                fontWeight: dt.isSameDate(currentDate)
                  ? FontWeight.w700
                  : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

//---  
bool hasWork(DateTime date, reports) {
  for (var report in reports) {
    if (report['application_periods'] != null) {
      for (var period in report['application_periods']) {
        DateTime begin = DateTime.parse(period['begin']);
        DateTime end = DateTime.parse(period['end']);

        if (date.isSameDate(begin) || date.isSameDate(end) || (begin.isBefore(date) && date.isBefore(end))) {
          return true;
        }
      }
    }
  }
  return false;
}
List getWorkForDay(DateTime selectedDate, reports) {
  List works = [];

  for (var report in reports) {
    bool showReport = false;
    if (report['application_periods'] != null) {
      for (var period in report['application_periods']) {
        DateTime begin = DateTime.parse(period['begin']);
        DateTime end = DateTime.parse(period['end']);

        if (selectedDate.isSameDate(begin) || selectedDate.isSameDate(end) || (begin.isBefore(selectedDate) && selectedDate.isBefore(end))) {
          showReport = true;
          break;
        }
      }
      if (showReport) {
        works.add(report);
      }
    }
  }
  return works;
}

class TraficWorkSchedule extends StatefulWidget {
  const TraficWorkSchedule({super.key});

  @override
  State<TraficWorkSchedule> createState() => _TraficWorkScheduleState();
}

class _TraficWorkScheduleState extends State<TraficWorkSchedule> {

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime selectedDate = DateTime.now();
  
  int dateIndex = 0;
  int daysInMonth = 0;

  void nextMonth() {
    DateTime newDate = DateTime(date.year, date.month + 1, 1);
    DateTime maxDate = DateTime(DateTime.now().year, DateTime.now().month + 3, 1);
    if (maxDate.isAfter(newDate)) {
      setState(() {
        date = newDate;
      });
      update();
    }
  }

  void previousMonth() {
    DateTime newDate = DateTime(date.year, date.month - 1, 1);
    DateTime minDate = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
    if (minDate.isBefore(newDate)) {
      setState(() {
        date = newDate;
      });
      update();
    }
  }

  void update() {
    setState(() {
      dateIndex = DateTime(date.year, date.month, 1).weekday;
      daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    });
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => update()); 
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: getNavigationBar(context),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Calendrier des travaux', style: appBarTitle),
              if (LINES.getLinesById(globals.lineTrafic['id']).libelle != '')
                Text(LINES.getLinesById(globals.lineTrafic['id']).libelle, style: appBarSubtitle),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          width: double.infinity,
          child: ListView(
            children: [
              
              Row(
                children: [

                  InkWell(
                    onTap: () => previousMonth(),
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Icon(NavikaIcons.chevron_left,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Center(
                      child: Text('${longMonth[date.month]?.capitalize()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Segoe Ui',
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () => nextMonth(),
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Icon(NavikaIcons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              Row(
                children: [
                  for(var day in shortDay.keys )
                    Expanded(
                      child: Center(
                        child: Text('${shortDay[day]}'
                        ),
                      ),
                    ),
                ],
              ),

              Column(
                children: [
                  for (var i = 0; i < 6; i++ )
                    Row(
                      children: [
                        for (var y = (i * 7)+1; y <= (i * 7)+7; y++ )
                          if (y >= dateIndex && y < daysInMonth + dateIndex)
                            buildDay(context, date, selectedDate, setSelectedDate, y - dateIndex + 1, [...globals.lineTrafic['reports']['current_work'], ...globals.lineTrafic['reports']['future_work']])
                          else
                            Expanded(
                              child: Container(),
                            ),
                      ],
                    )
                ],
              ),

// CTRAFIC
              if (globals.lineTrafic['reports'] != null)
                TraficDisruptions(
                  reports: getWorkForDay(selectedDate, [...globals.lineTrafic['reports']['current_work'], ...globals.lineTrafic['reports']['future_work']]),
                  ifEmpty: Container(
                    margin: const EdgeInsets.only(
                      top: 15
                    ),
                    child: Center(
                      child: Text('Aucun travaux prévu à cette date',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Segoe Ui',
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ),

              // globals.lineTrafic['reports']
            ],
          ),
        ),
      );
}
