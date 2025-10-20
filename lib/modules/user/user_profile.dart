import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/modules/user/components/user_game_stats.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Consumer<UserState>(
        builder: (context, userState, child) {
          User currentUser = userState.currentUser;
          return Consumer<GameScoreState>(
            builder: (context, gameScoreState, child) {
              bool isLoading = gameScoreState.isLoading;
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
                              currentUser.fullName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              currentUser.username,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 20.0),
                            UserGameStats(
                              gamesPlayed: gameScoreState.gamesPlayed,
                              bestScore: gameScoreState.bestScore,
                              averageScore: gameScoreState.averageScore,
                              bestRank: gameScoreState.bestRank,
                            ),
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
