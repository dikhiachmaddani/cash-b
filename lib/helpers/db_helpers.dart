// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cashbook/models/Finance.dart';
import 'package:cashbook/models/Users.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  final String tableUser = 'user';
  final String columnUserId = 'id';
  final String columnUserUsername = 'username';
  final String columnUserPassword = 'password';

  final String tableFinance = 'finance';
  final String columnFinanceId = 'id';
  final String columnFinanceType = 'type';
  final String columnFinanceDate = 'date';
  final String columnFinanceNominal = 'nominal';
  final String columnFinanceDesc = 'desc';

  DbHelper._internal();
  factory DbHelper() => _instance;

  // check db if is null
  Future<Database?> get _db async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDb();
    return _database;
  }

  // initial db
  Future<Database?> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'finance.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //create new table from db
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUser (
        $columnUserId INTEGER PRIMARY KEY,
        $columnUserUsername TEXT,
        $columnUserPassword TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableFinance (
        $columnFinanceId INTEGER PRIMARY KEY,
        $columnFinanceType TEXT,
        $columnFinanceDate INTEGER,
        $columnFinanceNominal REAL,
        $columnFinanceDesc TEXT
      )
    ''');

    await db.insert(tableUser, {
      columnUserUsername: 'user',
      columnUserPassword: 'user',
    });
  }

  //get all data
  Future<List?> getAllUser() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableUser, columns: [
      columnUserId,
      columnUserUsername,
      columnUserPassword,
    ]);

    return result.toList();
  }

  Future<Users?> getUserByUsername(String username) async {
    var dbClient = await _db;
    final List<Map<String, dynamic>> maps = await dbClient!.query(tableUser,
        where: '$columnUserUsername = ?', whereArgs: [username]);

    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getFinanceByType(String type) async {
    final dbClient = await _db;
    final result = await dbClient?.query(
      tableFinance,
      where: '$columnFinanceType = ?',
      whereArgs: ['expenses'],
    );
    log('$result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllFinance() async {
    var dbClient = await _db;
    var result = await dbClient!.query(tableFinance, columns: [
      columnFinanceId,
      columnFinanceType,
      columnFinanceNominal,
      columnFinanceDesc,
      columnFinanceDate,
    ]);

    return result;
  }

  Future<int?> insertUser(Map<String, dynamic> user) async {
    final dbClient = await _db;
    return await dbClient?.insert(tableUser, user);
  }

  Future<void> insertFinance(Finance finance) async {
    final dbClient = await _db;
    await dbClient!.insert(tableFinance, finance.toMap());
  }

  // //update data
  Future<int?> update(Users users) async {
    var dbClient = await _db;
    return await dbClient!.update(tableUser, users.toMap(),
        where: '$columnUserId = ?', whereArgs: [users.id]);
  }

  Future<double> getTotalIncome() async {
    final dbClient = await _db;
    final result = await dbClient!.rawQuery(
        'SELECT SUM($columnFinanceNominal) as total FROM $tableFinance WHERE $columnFinanceType = "income"');
    final total = result.first['total'] as double;
    return total;
  }

  Future<double> getTotalExpense() async {
    final dbClient = await _db;
    final result = await dbClient!.rawQuery(
        'SELECT SUM($columnFinanceNominal) as total FROM $tableFinance WHERE $columnFinanceType = "expense"');
    final total = result.first['total'] as double;
    return total;
  }

  Future<List<FlSpot>> getIncomeDataForChart() async {
    final dbClient = await _db;
    final result = await dbClient!.rawQuery('''
    SELECT $columnFinanceDate, $columnFinanceNominal
    FROM $tableFinance
    WHERE $columnFinanceType = 'income'
    ORDER BY $columnFinanceDate ASC
  ''');

    final data = <FlSpot>[];

    for (final row in result) {
      final dateInMillis = row[columnFinanceDate] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(dateInMillis);
      final nominal = row[columnFinanceNominal] as double;
      data.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), nominal));
    }

    return data;
  }
  
  Future<List<FlSpot>> getExpenseDataForChart() async {
    final dbClient = await _db;
    final result = await dbClient!.rawQuery('''
    SELECT $columnFinanceDate, $columnFinanceNominal
    FROM $tableFinance
    WHERE $columnFinanceType = 'expense'
    ORDER BY $columnFinanceDate ASC
  ''');

    final data = <FlSpot>[];

    for (final row in result) {
      final dateInMillis = row[columnFinanceDate] as int;
      final date = DateTime.fromMillisecondsSinceEpoch(dateInMillis);
      final nominal = row[columnFinanceNominal] as double;
      data.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), nominal));
    }

    return data;
  }
}
