import 'package:snake_app/core/constants/game_metadata_reference.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/utils/app_util.dart';

class GameScore {
  late int score;
  late String user;
  late String scoredAt;
  final DhisEvent dhisEvent;

  GameScore({required this.dhisEvent}) {
    scoredAt = AppUtil.formattedDateTimeIntoString(
      AppUtil.getDateIntoDateTimeFormat(dhisEvent.occurredAt ?? ''),
    );
    Map<String, dynamic> dataValueMap = {};
    for (var dataValue in dhisEvent.dataValues) {
      dataValueMap[dataValue.dataElement] = dataValue.value;
    }
    score = int.parse(
      dataValueMap[GameMetadataReference.gameScoreDataElement]?.toString() ??
          '0',
    );
    user = dataValueMap[GameMetadataReference.gameUsernameDataElement] ?? '';
  }

  @override
  String toString() {
    return 'GameScore{score: $score, user: $user, scoredAt: $scoredAt}';
  }
}
