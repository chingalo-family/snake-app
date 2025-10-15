import 'package:snake_app/core/constants/pagination_constant.dart';
import 'package:snake_app/core/models/dhis_data_value.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/offline_db/dhis_tracker_offline_provider/dhis_data_value_offline_provider.dart';
import 'package:snake_app/core/offline_db/offline_db_provider.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:sqflite/sqflite.dart';

class DhisEventOfflineProvider extends OfflineDbProvider {
  final String tableName = 'dhis_event';

  final String id = 'id';
  final String event = 'event';
  final String occurredAt = 'occurredAt';
  final String status = 'status';
  final String program = 'program';
  final String programStage = 'programStage';
  final String enrollment = 'enrollment';
  final String trackedEntity = 'trackedEntity';
  final String orgUnit = 'orgUnit';
  final String scheduledAt = 'scheduledAt';
  final String completedBy = 'completedBy';
  final String completedAt = 'completedAt';
  final String syncStatus = 'syncStatus';

  Future<void> addorUpdateEvents({required List<DhisEvent> events}) async {
    try {
      var dbClient = await db;
      List<List<dynamic>> chunkedEvents = AppUtil.chunkItems(
        items: events,
        size: PaginationConstant.insertBatchSize,
      );
      for (List<dynamic> eventsGroup in chunkedEvents) {
        var eventBatch = dbClient!.batch();
        for (DhisEvent event in eventsGroup) {
          Map data = event.toJson();
          data['id'] = data['event'];
          data.remove('dataValues');
          eventBatch.insert(
            tableName,
            data as Map<String, Object?>,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          await DhisDataValueOfflineProvider().addOrUpdateDhisEventDataValues(
            dhisEvents: [event],
          );
        }
        await eventBatch.commit(
          exclusive: true,
          noResult: true,
          continueOnError: true,
        );
      }
    } catch (e) {
      //
    }
  }

  Future<List<DhisEvent>> getUpdatedEvents({DateTime? lastSync}) async {
    List<DhisEvent> dhisEvents = [];
    int? lastUpdatedInMilliseconds = lastSync?.millisecondsSinceEpoch;
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          occurredAt,
          event,
          status,
          program,
          programStage,
          enrollment,
          trackedEntity,
          orgUnit,
          scheduledAt,
          completedAt,
          completedBy,
          syncStatus,
        ],
        where: lastUpdatedInMilliseconds != null ? '"lastUpdated" >= ?' : null,
        whereArgs: lastUpdatedInMilliseconds != null
            ? [lastUpdatedInMilliseconds]
            : null,
        orderBy: occurredAt,
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          List<DhisDataValue> dataValues = await DhisDataValueOfflineProvider()
              .getDhisEventDataValuesByEventId(eventId: map['id']);
          DhisEvent eventData = DhisEvent.fromJson(map as Map<String, dynamic>);
          eventData.dataValues = dataValues;
          dhisEvents.add(eventData);
        }
      }
    } catch (error) {
      //
    }
    return dhisEvents;
  }

  Future<List<DhisEvent>> getOfflineDhis2Events({
    required String eventSyncStatus,
    required List<String> orgUnitIds,
  }) async {
    List<DhisEvent> dhisEvents = [];
    String questionMark = (orgUnitIds)
        .map((orgUnitId) => '?')
        .toList()
        .join(',');
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          occurredAt,
          event,
          status,
          program,
          programStage,
          enrollment,
          trackedEntity,
          orgUnit,
          scheduledAt,
          completedAt,
          completedBy,
          syncStatus,
        ],
        where: '$syncStatus = ? AND $orgUnit IN ($questionMark)',
        whereArgs: [eventSyncStatus, ...orgUnitIds],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          List<DhisDataValue> dataValues = await DhisDataValueOfflineProvider()
              .getDhisEventDataValuesByEventId(eventId: map['id']);
          DhisEvent eventData = DhisEvent.fromJson(map as Map<String, dynamic>);
          eventData.dataValues = dataValues;
          dhisEvents.add(eventData);
        }
      }
    } catch (error) {
      //
    }
    return dhisEvents;
  }
}
