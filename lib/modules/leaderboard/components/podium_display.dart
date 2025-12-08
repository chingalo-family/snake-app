import 'package:flutter/material.dart';
import 'package:snake_app/core/models/game_score.dart';

class PodiumDisplay extends StatelessWidget {
  const PodiumDisplay({
    super.key,
    required this.topScores,
  });

  final List<GameScore> topScores;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (topScores.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get top 3 scores, fill with nulls if less than 3
    final first = topScores.isNotEmpty ? topScores[0] : null;
    final second = topScores.length > 1 ? topScores[1] : null;
    final third = topScores.length > 2 ? topScores[2] : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second place
          if (second != null)
            _buildPodiumPlayer(
              context,
              second,
              2,
              80,
              colorScheme.primary.withOpacity(0.7),
            ),
          const SizedBox(width: 10),
          // First place (center, larger)
          if (first != null)
            _buildPodiumPlayer(
              context,
              first,
              1,
              100,
              colorScheme.primary,
              showCrown: true,
            ),
          const SizedBox(width: 10),
          // Third place
          if (third != null)
            _buildPodiumPlayer(
              context,
              third,
              3,
              80,
              colorScheme.primary.withOpacity(0.5),
            ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(
    BuildContext context,
    GameScore gameScore,
    int rank,
    double size,
    Color borderColor, {
    bool showCrown = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Crown for first place
        if (showCrown)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '👑',
              style: TextStyle(fontSize: size * 0.3),
            ),
          ),
        // Avatar with border
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 4,
                ),
                color: Colors.grey.shade800,
              ),
              child: Center(
                child: Text(
                  gameScore.user.isNotEmpty 
                      ? gameScore.user[0].toUpperCase() 
                      : '?',
                  style: TextStyle(
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Rank badge
            Positioned(
              bottom: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Player name
        SizedBox(
          width: 100,
          child: Text(
            gameScore.user,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        // Points with fire emoji
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '${gameScore.score} points',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
