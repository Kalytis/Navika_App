import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final Function()? onTap;
  final IconData? icon;
  final TextStyle? style;
  final String text;

  const SearchBox({
    required this.text,
    this.onTap,
    this.icon,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(500),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(500),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, 
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 25,
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                child: Text(text,
                  style: style ?? TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer
                  ),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
