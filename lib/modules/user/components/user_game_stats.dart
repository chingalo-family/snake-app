import 'package:flutter/material.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/icon_reference.dart';

class UserGameStats extends StatelessWidget {
  const UserGameStats({
    super.key,
    required this.gamesPlayed,
    required this.bestScore,
    required this.averageScore,
    required this.bestRank,
  });

  final String gamesPlayed;
  final String bestScore;
  final String averageScore;
  final String bestRank;

  Widget _buildStatItem(BuildContext context, String title, String value) {
    return MaterialCard(
      elevation: 3.0,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10.0),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialCard(
      elevation: 0.0,
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  IconReference.trophy,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    "Statistics",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(context, "Games Played", gamesPlayed),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildStatItem(context, "Best Score", bestScore),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(context, "Average Score", averageScore),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: _buildStatItem(context, "Best Rank", "#$bestRank"),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
