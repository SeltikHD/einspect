import 'package:sqflite/sqflite.dart';

abstract base class DatabaseTable {
  String get tableName;
  String get createTableQuery;
  List<String> get createIndicesQueries => const [];

  Future<void> create(Database db) async {
    await db.execute(createTableQuery);
    for (final query in createIndicesQueries) {
      await db.execute(query);
    }
  }
}
