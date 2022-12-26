import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'ml ',
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              'bank',
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
