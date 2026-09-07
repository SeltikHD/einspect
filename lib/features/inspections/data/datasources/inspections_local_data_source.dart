import 'dart:io';

import 'package:einspect/core/database/db_helper.dart';
import 'package:einspect/core/database/tables/inspections_table.dart';
import 'package:einspect/core/errors/failure.dart';
import 'package:einspect/features/inspections/data/models/inspection_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class InspectionsLocalDataSource {
  Future<void> insertOrUpdate(InspectionModel inspection);
  Future<InspectionModel?> findByClientId({
    required String clientId,
    required String userId,
  });
  Future<InspectionModel?> findByWorkOrderId({
    required String workOrderId,
    required String userId,
  });
  Future<List<InspectionModel>> findAll({
    required String userId,
    String? status,
  });

  /// Moves temporary camera/gallery evidence to app documents directory to survive OS cache cleaning
  Future<String> savePermanentPhoto({
    required String sourcePath,
    required String clientId,
  });

  /// Deletes stored evidence file from disk when technician removes it from draft
  Future<void> deletePermanentPhoto(String filePath);

  /// Pulls all unacknowledged inspections needing background remote transmission.
  Future<List<InspectionModel>> findSyncQueue({required String userId});
}

final class InspectionsLocalDataSourceImpl
    implements InspectionsLocalDataSource {
  final DbHelper _dbHelper;

  const InspectionsLocalDataSourceImpl({required this._dbHelper});

  @override
  Future<void> insertOrUpdate(InspectionModel inspection) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        InspectionsTable().tableName,
        inspection.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException {
      throw const DatabaseFailure(
        'Não foi possível salvar a inspeção localmente.',
      );
    }
  }

  @override
  Future<InspectionModel?> findByClientId({
    required String clientId,
    required String userId,
  }) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        InspectionsTable().tableName,
        where:
            '${InspectionsTable.columnClientId} = ? AND ${InspectionsTable.columnUserId} = ?',
        whereArgs: [clientId, userId],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return InspectionModel.fromDatabase(results.first);
    } on DatabaseException {
      throw const DatabaseFailure(
        'Não foi possível consultar a inspeção local.',
      );
    }
  }

  @override
  Future<InspectionModel?> findByWorkOrderId({
    required String workOrderId,
    required String userId,
  }) async {
    try {
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
    } on DatabaseException {
      throw const DatabaseFailure(
        'Não foi possível consultar a inspeção local.',
      );
    }
  }

  @override
  Future<List<InspectionModel>> findAll({
    required String userId,
    String? status,
  }) async {
    try {
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
    } on DatabaseException {
      throw const DatabaseFailure(
        'Não foi possível carregar o histórico local.',
      );
    }
  }

  @override
  Future<String> savePermanentPhoto({
    required String sourcePath,
    required String clientId,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final inspectionsDir = Directory('${appDir.path}/inspections');

    if (!await inspectionsDir.exists()) {
      await inspectionsDir.create(recursive: true);
    }

    final extension = sourcePath.contains('.')
        ? sourcePath.split('.').last
        : 'jpg';
    final targetFileName =
        '${clientId}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final targetPath = '${inspectionsDir.path}/$targetFileName';

    final savedFile = await File(sourcePath).copy(targetPath);
    return savedFile.path;
  }

  @override
  Future<void> deletePermanentPhoto(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<InspectionModel>> findSyncQueue({required String userId}) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        InspectionsTable().tableName,
        where:
            '(${InspectionsTable.columnStatus} = ? OR ${InspectionsTable.columnStatus} = ?) AND ${InspectionsTable.columnUserId} = ?',
        whereArgs: ['pending', 'failed', userId],
        orderBy: '${InspectionsTable.columnCreatedAt} ASC',
      );
      return results.map(InspectionModel.fromDatabase).toList();
    } on DatabaseException {
      throw const DatabaseFailure('Não foi possível carregar a fila local.');
    }
  }
}
