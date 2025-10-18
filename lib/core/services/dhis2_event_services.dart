import 'dart:convert';

import 'package:snake_app/core/constants/dhis2_connection.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/offline_db/dhis_tracker_offline_provider/dhis_event_offline_provider.dart';
import 'package:snake_app/core/services/dhis2_http_service.dart';
import 'package:snake_app/core/services/preference_service.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/core/utils/app_util.dart';

class Dhis2EventServices {
  final int pageSize = 100;
  final String lastRecordDownloadDateKey = 'lastRecordDownloadDateKey';

  Future<void> setLastRecordDownloadDate() async {
    try {
      User? user = await UserService().getCurrentUser();
      await PreferenceService.setPreferenceValue(
        '${lastRecordDownloadDateKey}_${user?.id}',
        AppUtil.formattedDateTimeIntoString(DateTime.now()),
      );
    } catch (e) {
      //
    }
  }

  Future<String> getLastRecordDownloadDate() async {
    String lastDate = '';
    try {
      User? user = await UserService().getCurrentUser();
      var date = await PreferenceService.getPreferenceValue(
        '${lastRecordDownloadDateKey}_${user?.id}',
      );
      lastDate = date ?? lastDate;
    } catch (e) {
      //
    }
    return lastDate;
  }

  Future<List<Map<String, String>>> getPaginationForDhis2EventsFromServer({
    required String orgUnitId,
  }) async {
    List<Map<String, String>> paginations = [];
    try {
      String lastSyncDate = await getLastRecordDownloadDate();
      User? user = await UserService().getCurrentUser();
      Dhis2HttpService http = Dhis2HttpService(
        username: user?.username ?? Dhis2Connection.username,
        password: user?.password ?? Dhis2Connection.password,
      );
      const url = 'api/tracker/events';
      var filterQueryParamter = {
        'orgUnit': orgUnitId,
        'order': 'updatedAt:desc',
      };
      if (lastSyncDate.isNotEmpty) {
        filterQueryParamter['updatedAfter'] = lastSyncDate;
      }
      var pageResponse = await http.httpGetPagination(url, filterQueryParamter);
      paginations = AppUtil.getPaginationFilters(
        response: pageResponse,
        pageSize: pageSize,
      );
    } catch (e) {
      //
    }
    return paginations;
  }

  Future<List<DhisEvent>> syncDhis2EventsFromServer({
    required String orgUnitId,
    required Map<String, String> pagefilter,
  }) async {
    List<DhisEvent> dhis2Events = [];
    try {
      String lastSyncDate = await getLastRecordDownloadDate();
      User? user = await UserService().getCurrentUser();
      Dhis2HttpService http = Dhis2HttpService(
        username: user?.username ?? Dhis2Connection.username,
        password: user?.password ?? Dhis2Connection.password,
      );
      const url = 'api/tracker/events';
      var queryParameters = {
        'orgUnit': orgUnitId,
        'order': 'updatedAt:desc',
        'fields':
            'event,occurredAt,status,program,programStage,enrollment,trackedEntity,orgUnit,scheduledAt,completedBy,completedAt,dataValues[value,dataElement]',
      };
      if (lastSyncDate.isNotEmpty) {
        queryParameters['updatedAfter'] = lastSyncDate;
      }
      queryParameters.addAll(pagefilter);
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        Map body = json.decode(response.body);
        for (dynamic json in body['events'] ?? []) {
          dhis2Events.add(DhisEvent.fromJson(json));
        }
      }
      await savingDhisEvents(events: dhis2Events);
    } catch (e) {
      rethrow;
    }
    return dhis2Events;
  }

  Future<List<String>> syncDhis2EventsToServer({
    required List<DhisEvent> dhisEvents,
  }) async {
    List<String> unsyncedEvents = [];
    const url = 'api/tracker';
    var queryParameters = {
      "importStrategy": "CREATE_AND_UPDATE",
      "async": "false",
    };
    try {
      User? user = await UserService().getCurrentUser();
      Dhis2HttpService http = Dhis2HttpService(
        username: user?.username ?? Dhis2Connection.username,
        password: user?.password ?? Dhis2Connection.password,
      );
      Map<String, dynamic> body = {
        "events": dhisEvents.map((DhisEvent event) {
          return event.toJson();
        }).toList(),
      };
      var response = await http.httpPost(
        url,
        json.encode(body),
        queryParameters: queryParameters,
      );
      Map responseBody = json.decode(response.body);
      Map validationReport = responseBody['validationReport'] ?? {};
      for (var error in validationReport['errorReports'] ?? []) {
        if (error.keys.contains('uid')) {
          unsyncedEvents.add(error['uid']);
        }
      }
      for (var error in validationReport['warningReports'] ?? []) {
        if (error.keys.contains('uid')) {
          unsyncedEvents.add(error['uid']);
        }
      }
    } catch (e) {
      unsyncedEvents = dhisEvents
          .map((DhisEvent event) => event.event)
          .toList();
    }
    return unsyncedEvents;
  }

  Future<List<DhisEvent>> getOfflineDhis2Events({
    required String status,
    required List<String> orgUnitIds,
  }) async {
    return DhisEventOfflineProvider().getOfflineDhis2Events(
      eventSyncStatus: status,
      orgUnitIds: orgUnitIds,
    );
  }

  Future<List<DhisEvent>> getAllEvents() async {
    return DhisEventOfflineProvider().getAllEvents();
  }

  Future<void> savingDhisEvents({required List<DhisEvent> events}) async {
    try {
      await DhisEventOfflineProvider().addorUpdateEvents(events: events);
    } catch (e) {
      //
    }
  }
}
