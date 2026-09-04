import 'package:sqflite/sqflite.dart';

import '../../../../core/database/db_helper.dart';
import '../../../../core/database/tables/inspections_table.dart';
import '../models/inspection_model.dart';

abstract interface class InspectionsLocalDataSource {
  Future<void> insertOrUpdate(InspectionModel inspection);
  Future<InspectionModel?> findByClientId(String clientId);
  Future<InspectionModel?> findByWorkOrderId({
    required String workOrderId,
    required String userId,
  });
  Future<List<InspectionModel>> findAll({
    required String userId,
    String? status,
  });

  /// Pulls all unacknowledged inspections needing background remote transmission.
  Future<List<InspectionModel>> findSyncQueue({String? userId});
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
  Future<InspectionModel?> findByWorkOrderId({
    required String workOrderId,
    required String userId,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      InspectionsTable().tableName,
      where:
          '${InspectionsTable.columnWorkOrderId} = ? AND ${InspectionsTable.columnUserId} = ?',
      whereArgs: [workOrderId, userId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return InspectionModel.fromDatabase(results.first);
  }

  @override
  Future<List<InspectionModel>> findAll({
    required String userId,
    String? status,
  }) async {
    final db = await _dbHelper.database;
    final whereClauses = ['${InspectionsTable.columnUserId} = ?'];
    final whereArgs = <dynamic>[userId];

    if (status != null) {
      whereClauses.add('${InspectionsTable.columnStatus} = ?');
      whereArgs.add(status);
    }

    final results = await db.query(
      InspectionsTable().tableName,
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: '${InspectionsTable.columnCreatedAt} DESC',
    );
    return results.map(InspectionModel.fromDatabase).toList();
  }

  @override
  Future<List<InspectionModel>> findSyncQueue({String? userId}) async {
    final db = await _dbHelper.database;
    final whereClauses = [
      '(${InspectionsTable.columnStatus} = ? OR ${InspectionsTable.columnStatus} = ?)',
    ];
    final whereArgs = <dynamic>['pending', 'failed'];

    if (userId != null) {
      whereClauses.add('${InspectionsTable.columnUserId} = ?');
      whereArgs.add(userId);
    }

    final results = await db.query(
      InspectionsTable().tableName,
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: '${InspectionsTable.columnCreatedAt} ASC',
    );
    return results.map(InspectionModel.fromDatabase).toList();
  }
}
