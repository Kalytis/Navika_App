import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:navika/src/icons/navika_icons_icons.dart';
import 'package:navika/src/screens/home_settings.dart';
import 'package:navika/src/style.dart';
import 'package:navika/src/widgets/utils/icon_elevated.dart';
import 'package:navika/src/data/global.dart' as globals;
import 'package:navika/src/data/app.dart' as app;

class HomeWidgetSponsor extends StatelessWidget {
  final bool canBeDeactivated;
  final Color? backgroundColor;
  final Color? color;

  HomeWidgetSponsor({
    this.canBeDeactivated = false,
    this.backgroundColor,
    this.color,
    super.key,
  });
  
  final ChromeSafariBrowser browser = ChromeSafariBrowser();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only( left: 15.0, top: 10, right: 15.0, bottom: 10.0),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(255, 221, 73, 73).withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  NavikaIcons.hearts,
                  color: Color.fromARGB(255, 255, 0, 0),
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text('Soutenez Navika !',
                    style: TextStyle(
                      color: color ?? Theme.of(context).colorScheme.onSurface,
                      fontSize: 16, 
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text('Navika est une application open-source, totalement gratuite et surtout sans pub. Si Navika vous plaît, vous pouvez soutenir son développement en laissant une petite pièce.',
                  style: TextStyle(
                    color: color ?? Theme.of(context).colorScheme.onSurface,
                    fontSize: 16
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Text('Merci pour votre soutien !',
                    style: TextStyle(
                      color: Color.fromARGB(255, 221, 73, 73),
                      fontSize: 16, 
                      fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: IconElevatedButton(
                icon: NavikaIcons.hearts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 221, 73, 73),
                  foregroundColor: const Color(0xffffffff),
                ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                text: 'Soutenir',
                onPressed: () async {
                  await browser.open(
                    url: Uri.parse(app.APP_SPONSOR), options: ChromeSafariBrowserClassOptions()
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (canBeDeactivated)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconElevatedButton(
                    icon: NavikaIcons.past,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffffff),
                      foregroundColor: const Color.fromARGB(255, 221, 73, 73),
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    text: 'Plus tard',
                    onPressed: () {
                      DateTime now = DateTime.now().add(const Duration(days: 7));
                      String formattedDate = DateFormat('dd-MM-yyyy').format(now);
                      globals.hiveBox.put('sponsorHideDate', formattedDate);
                      handleSwitch(false, 'sponsor');
                    },
                  ),
                  IconElevatedButton(
                    icon: NavikaIcons.cancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffffff),
                      foregroundColor: const Color.fromARGB(255, 221, 73, 73),
                    ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                    text: 'Masquer',
                    onPressed: () {
                      handleSwitch(false, 'sponsor');
                      FloatingSnackBar(
                        message: 'Compris, ce message n’apparaîtra plus.',
                        context: context,
                        textColor: mainColor(context),
                        textStyle: snackBarText,
                        duration: const Duration(milliseconds: 4000),
                        backgroundColor: const Color(0xff272727),
                      );
                    },
                  )
                ],
              ),
          ],
        ),
      );
}
