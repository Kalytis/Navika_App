import 'package:flutter/material.dart';
import 'package:navika/src/icons/navika_icons_icons.dart';
import 'package:navika/src/style/style.dart';
import 'package:navika/src/utils.dart';

class Emission extends StatelessWidget {
  final Map journey;

  const Emission({
    required this.journey,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left:15.0, top:10, right:15.0, bottom:10.0),
    margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom:10.0),
    decoration: BoxDecoration(
      color: const Color(0xff008b5b).withOpacity(0.2),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right:5),
                child: const Image(
                  image: AssetImage('assets/img/leaf.png'),
                  height: 25,
                ),
              ),
              Expanded(
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text('CO₂ emis ce trajet :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Text('${journey['co2_emission'].toStringAsFixed(2)}g',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ]
    ),
  );
}
