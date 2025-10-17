import 'package:flutter/material.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/icon_reference.dart';

class GameHighlightContainer extends StatelessWidget {
  const GameHighlightContainer({super.key});

  Widget _getCardItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
  }) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: MaterialCard(
        borderRadius: 10.0,
        elevation: 0.0,
        body: Container(
          alignment: Alignment.center,
          width: size.shortestSide * 0.40,
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              Text(icon, style: Theme.of(context).textTheme.headlineLarge),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              Text(subtitle, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getCardItem(
          context,
          icon: IconReference.lightning,
          title: 'Fast Paced',
          subtitle: 'Quick Rounds',
        ),
        _getCardItem(
          context,
          icon: IconReference.trophy,
          title: 'Complete',
          subtitle: 'Global ranks',
        ),
      ],
    );
  }
}
