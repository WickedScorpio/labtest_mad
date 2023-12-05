import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BMIDatabase {
  static final String _dbName = "bitp3453_bmi";
  static final String _tblName = "bmi";
  static final String _colUsername = "username";
  static final String _colWeight = "weight";
  static final String _colHeight = "height";
  static final String _colGender = "gender";
  static final String _colStatus = "bmi_status";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, _dbName),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tblName (
            $_colUsername TEXT,
            $_colWeight REAL,
            $_colHeight REAL,
            $_colGender TEXT,
            $_colStatus TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertBMI(String username, double weight, double height, String gender, String status) async {
    final db = await database;
    await db.insert(
      _tblName,
      {
        _colUsername: username,
        _colWeight: weight,
        _colHeight: height,
        _colGender: gender,
        _colStatus: status,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getBMIRecords() async {
    final db = await database;
    return db.query(_tblName);
  }
}