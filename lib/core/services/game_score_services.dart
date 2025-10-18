import 'package:snake_app/core/constants/app_sync_status.dart';
import 'package:snake_app/core/constants/game_metadata_reference.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/dhis2_event_services.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:snake_app/core/utils/entry_form_util.dart';

class GameScoreServices {
  final int pageSize = 50;
  Future submitGameScore({required int score, required int level}) async {
    try {
      User? currentUser = await UserService().getCurrentUser();
      String username = '';
      String orgUnit = '';
      if (currentUser != null) {
        username = currentUser.username;
        orgUnit = currentUser.userOrgUnitIds?.first ?? '';
      }
      Map<String, dynamic> dataObject = {"completedBy": username};
      for (String dataElement in GameMetadataReference.dataElementIds) {
        switch (dataElement) {
          case GameMetadataReference.gameScoreDataElement:
            dataObject[dataElement] = score;
          case GameMetadataReference.gameLevelDataElement:
            dataObject[dataElement] = level;
          case GameMetadataReference.gameUsernameDataElement:
            dataObject[dataElement] = username;
          default:
            break;
        }
      }
      List<DhisEvent> offlineEvents = await Dhis2EventServices()
          .getOfflineDhis2Events(
            status: AppSyncStatus.notSynced,
            orgUnitIds: [orgUnit],
          );
      offlineEvents.add(
        EntryFormUtil.getDhis2EventPayLoad(
          dataObject: dataObject,
          dataElementIds: GameMetadataReference.dataElementIds,
          program: GameMetadataReference.program,
          programStage: GameMetadataReference.programStage,
          orgUnit: orgUnit,
        ),
      );
      List<List<dynamic>> chunkedDhis2Events = AppUtil.chunkItems(
        items: offlineEvents,
        size: pageSize,
      );
      for (List<dynamic> chunkedDhis2EventList in chunkedDhis2Events) {
        List<String> unsyncedEvents = await Dhis2EventServices()
            .syncDhis2EventsToServer(
              dhisEvents: chunkedDhis2EventList as List<DhisEvent>,
            );
        await Dhis2EventServices().savingDhisEvents(
          events: (chunkedDhis2EventList).map((DhisEvent dhisEvent) {
            dhisEvent.syncStatus = unsyncedEvents.contains(dhisEvent.event)
                ? AppSyncStatus.notSynced
                : AppSyncStatus.synced;
            return dhisEvent;
          }).toList(),
        );
      }
    } catch (error) {
      //
      print('Error submitting snake score: $error');
    }
  }

  Future downloadGameScoresFromServer({required String orgUnitId}) async {
    try {
      List<Map<String, String>> pagefilters = await Dhis2EventServices()
          .getPaginationForDhis2EventsFromServer(orgUnitId: orgUnitId);
      for (Map<String, String> pagefilter in pagefilters) {
        await Dhis2EventServices().syncDhis2EventsFromServer(
          orgUnitId: orgUnitId,
          pagefilter: pagefilter,
        );
      }
    } catch (error) {
      //
      print('Error downloading snake scores: $error');
    }
  }
}
