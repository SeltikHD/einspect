import 'package:sqflite/sqflite.dart';

import '../../../../core/database/db_helper.dart';
import '../../../../core/database/tables/inspections_table.dart';
import '../models/inspection_model.dart';

abstract interface class InspectionsLocalDataSource {
  Future<void> insertOrUpdate(InspectionModel inspection);
  Future<InspectionModel?> findByClientId(String clientId);
  Future<InspectionModel?> findByWorkOrderId(String workOrderId);
  Future<List<InspectionModel>> findAll({String? status});

  /// Pulls all unacknowledged inspections needing background remote transmission.
  Future<List<InspectionModel>> findSyncQueue();
}

final class InspectionsLocalDataSourceImpl
    implements InspectionsLocalDataSource {
  final DbHelper _dbHelper;

  const InspectionsLocalDataSourceImpl({required this._dbHelper});

  @override
  Future<void> insertOrUpdate(InspectionModel inspection) async {
    final db = await _dbHelper.database;
    await db.insert(
      InspectionsTable().tableName,
      inspection.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<InspectionModel?> findByClientId(String clientId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      InspectionsTable().tableName,
      where: '${InspectionsTable.columnClientId} = ?',
      whereArgs: [clientId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return InspectionModel.fromDatabase(results.first);
  }

  @override
  Future<InspectionModel?> findByWorkOrderId(String workOrderId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      InspectionsTable().tableName,
      where: '${InspectionsTable.columnWorkOrderId} = ?',
      whereArgs: [workOrderId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return InspectionModel.fromDatabase(results.first);
  }

  @override
  Future<List<InspectionModel>> findAll({String? status}) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      InspectionsTable().tableName,
      where: status != null ? '${InspectionsTable.columnStatus} = ?' : null,
      whereArgs: status != null ? [status] : null,
      orderBy: '${InspectionsTable.columnCreatedAt} DESC',
    );

    return results.map(InspectionModel.fromDatabase).toList();
  }

  @override
  Future<List<InspectionModel>> findSyncQueue() async {
    final db = await _dbHelper.database;
    // Dispatches pending items as well as previously failed attempts for automated retry
    final results = await db.query(
      InspectionsTable().tableName,
      where:
          '${InspectionsTable.columnStatus} = ? OR ${InspectionsTable.columnStatus} = ?',
      whereArgs: ['pending', 'failed'],
      orderBy: '${InspectionsTable.columnCreatedAt} ASC',
    );

    return results.map(InspectionModel.fromDatabase).toList();
  }
}
