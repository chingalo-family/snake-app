import 'package:flutter/material.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/models/game_score.dart';

class GameScoreCard extends StatelessWidget {
  const GameScoreCard({super.key, required this.rank, required this.gameScore});

  final int rank;
  final GameScore gameScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialCard(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rank == 1
                    ? '🥇'
                    : rank == 2
                    ? '🥈'
                    : rank == 3
                    ? '🥉'
                    : "#$rank",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameScore.user,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      gameScore.scoredAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Chip(
                backgroundColor: Theme.of(context).colorScheme.primary,
                labelStyle: Theme.of(context).textTheme.titleSmall,
                label: Text('${gameScore.score}'),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
