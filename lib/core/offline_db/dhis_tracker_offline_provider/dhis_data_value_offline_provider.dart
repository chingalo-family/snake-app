import 'package:snake_app/core/constants/pagination_constant.dart';
import 'package:snake_app/core/models/dhis_data_value.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/offline_db/offline_db_provider.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:sqflite/sqflite.dart';

class DhisDataValueOfflineProvider extends OfflineDbProvider {
  final String tableName = 'dhis_data_value';

  final String id = 'id';
  final String event = 'event';
  final String dataElement = 'dataElement';
  final String value = 'value';

  Future addOrUpdateDhisEventDataValues({
    required List<DhisEvent> dhisEvents,
  }) async {
    var dbClient = await db;
    try {
      List<List<dynamic>> chunkedDhisEventDataValues = AppUtil.chunkItems(
        items: dhisEvents
            .map((DhisEvent dhis2Event) {
              return dhis2Event.dataValues;
            })
            .toList()
            .expand((dataValue) => dataValue)
            .toList(),
        size: PaginationConstant.insertBatchSize,
      );
      for (List<dynamic> chunkedDhisEventDataValueList
          in chunkedDhisEventDataValues) {
        var dhisEventDataValueBatch = dbClient!.batch();
        for (DhisDataValue dhisDataValue in chunkedDhisEventDataValueList) {
          dhisEventDataValueBatch.insert(
            tableName,
            dhisDataValue.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await dhisEventDataValueBatch.commit(
          noResult: true,
          continueOnError: true,
        );
      }
    } catch (error) {
      //
    }
  }

  Future<List<DhisDataValue>> getDhisEventDataValuesByEventId({
    required String eventId,
  }) async {
    List<DhisDataValue> dhisDataValues = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [id, event, dataElement, value],
        where: '$event = ?',
        whereArgs: [eventId],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          dhisDataValues.add(
            DhisDataValue.fromJson(map as Map<String, dynamic>),
          );
        }
      }
    } catch (error) {
      //
    }
    return dhisDataValues;
  }
}
