import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/models/power_up.dart';

/// Modern power-up display widget showing active power-up with countdown
class PowerUpDisplay extends StatelessWidget {
  const PowerUpDisplay({super.key});

  Color _getPowerUpColor(PowerUpType type) {
    switch (type) {
      case PowerUpType.speedBoost:
        return Colors.amber;
      case PowerUpType.shield:
        return Colors.blue;
      case PowerUpType.scoreMultiplier:
        return Colors.purple;
      case PowerUpType.slowMotion:
        return Colors.cyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SnakeState>(
      builder: (context, snakeState, child) {
        final PowerUp? activePowerUp = snakeState.activePowerUp;
        final int remainingSeconds = snakeState.powerUpRemainingSeconds;

        if (activePowerUp == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getPowerUpColor(activePowerUp.type).withOpacity(0.8),
                _getPowerUpColor(activePowerUp.type).withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _getPowerUpColor(activePowerUp.type).withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activePowerUp.icon,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                activePowerUp.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${remainingSeconds}s',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
