import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/models/game_score.dart';
import 'package:snake_app/modules/leaderboard/components/game_score_card.dart';
import 'package:snake_app/modules/leaderboard/components/leaderboard_tabs.dart';
import 'package:snake_app/modules/leaderboard/components/podium_display.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  int _selectedTab = 0;

  void _onTabChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
    // TODO: Implement filtering logic based on tab selection
    print('Selected Tab: $_selectedTab');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Consumer<GameScoreState>(
        builder: (context, gameScoreState, child) {
          bool isLoading = gameScoreState.isLoading;
          List<GameScore> gameScores = gameScoreState.gameScores;

          // Split scores into top 3 and rest
          List<GameScore> topScores = gameScores.take(3).toList();
          List<GameScore> remainingScores = gameScores.skip(3).toList();

          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          "Leaderboard",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),

                        // Tabs
                        LeaderboardTabs(onTabChanged: _onTabChanged),
                        const SizedBox(height: 20.0),

                        // Top 3 Podium
                        PodiumDisplay(topScores: topScores),
                        const SizedBox(height: 30.0),

                        // Table headers if there are remaining scores
                        if (remainingScores.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    'Rank',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 64.0),
                                Expanded(
                                  child: Text(
                                    'Player',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                Text(
                                  'Points',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                ),
                                const SizedBox(width: 16.0),
                              ],
                            ),
                          ),

                        // Remaining scores list
                        ...remainingScores.map((GameScore gameScore) {
                          int index = gameScores.indexOf(gameScore);
                          int rank = index + 1;
                          return GameScoreCard(
                            rank: rank,
                            gameScore: gameScore,
                          );
                        }),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
