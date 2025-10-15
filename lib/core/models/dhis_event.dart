import 'package:snake_app/core/constants/app_sync_status.dart';
import 'package:snake_app/core/models/dhis_data_value.dart';

class DhisEvent {
  final String event;
  final String? occurredAt;
  final String status;
  final String program;
  final String programStage;
  final String? enrollment;
  final String? trackedEntity;
  final String orgUnit;
  final String? scheduledAt;
  final String? completedBy;
  final String? completedAt;
  List<DhisDataValue> dataValues;
  String? syncStatus;

  DhisEvent({
    required this.event,
    required this.status,
    required this.program,
    required this.programStage,
    required this.orgUnit,
    this.dataValues = const [],
    this.occurredAt,
    this.scheduledAt,
    this.completedBy,
    this.completedAt,
    this.enrollment,
    this.trackedEntity,
    this.syncStatus = AppSyncStatus.synced,
  });

  bool get isSync => syncStatus == AppSyncStatus.synced;

  factory DhisEvent.fromJson(Map<String, dynamic> json) {
    return DhisEvent(
      event: json['event'],
      occurredAt: json['occurredAt'],
      status: json['status'],
      program: json['program'],
      programStage: json['programStage'],
      enrollment: json['enrollment'],
      trackedEntity: json['trackedEntity'],
      orgUnit: json['orgUnit'],
      scheduledAt: json['scheduledAt'] ?? '',
      completedBy: json['completedBy'] ?? '',
      completedAt: json['completedAt'] ?? '',
      syncStatus: json['syncStatus'] ?? AppSyncStatus.synced,
      dataValues: json['dataValues'] != null
          ? (json['dataValues'] as List)
                .map(
                  (jsonData) => DhisDataValue.fromJson({
                    ...jsonData,
                    'event': json['event'] ?? '',
                  }),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    var json = {
      'event': event,
      'occurredAt': occurredAt,
      'status': status,
      'program': program,
      'programStage': programStage,
      'enrollment': enrollment,
      'trackedEntity': trackedEntity,
      'orgUnit': orgUnit,
      'scheduledAt': scheduledAt,
      'completedBy': completedBy,
      'completedAt': completedAt,
      'syncStatus': syncStatus,
      'dataValues': dataValues
          .map((DhisDataValue dataValue) => dataValue.toJson())
          .toList(),
    };
    json.removeWhere((key, value) => value == '' || value == null);
    return json;
  }

  @override
  String toString() {
    return '< $event $program $programStage $occurredAt >';
  }
}
