import 'package:aiso/models/db_timestamps_model.dart';

class ReportRun {
  final String id;
  final String reportId;
  final String status;
  final DbTimestamps dbTimestamps;

  ReportRun({
    required this.id,
    required this.reportId, 
    required this.status, 
    required this.dbTimestamps,
    });

  factory ReportRun.fromJson(Map<String, dynamic> json) {
    return ReportRun(
      id: json['id'] as String,
      reportId: json['report_id'] as String,
      status: json['status'] as String,
      dbTimestamps: DbTimestamps.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'status': status,
      // ...dbTimestamps.toJson(), // merges timestamp fields
    };
  }

}