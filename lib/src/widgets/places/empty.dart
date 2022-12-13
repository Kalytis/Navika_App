import 'package:flutter/material.dart';

class PlacesEmpty extends StatelessWidget {

	const PlacesEmpty({
		super.key,
	});

	@override
	Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top:40.0),
    child: Center(
      child: Text('🔭 Nous n\'avons rien trouvé...', 
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700
        ),
      ),
    ),
  );
}