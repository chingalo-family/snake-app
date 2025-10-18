import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/models/game_score.dart';
import 'package:snake_app/modules/leaderboard/components/game_score_card.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Consumer<GameScoreState>(
        builder: (context, gameScoreState, child) {
          bool isLoading = gameScoreState.isLoading;
          List<GameScore> gameScores = gameScoreState.gameScores;
          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Text(
                          IconReference.trophy,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(fontSize: 40.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          "Leaderboard",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "Top players worldwide",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 15.0),
                        ...gameScores.map((GameScore gameScore) {
                          int index = gameScores.indexOf(gameScore);
                          int rank = index + 1;
                          return GameScoreCard(
                            rank: rank,
                            gameScore: gameScore,
                          );
                        }),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
