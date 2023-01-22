import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Esta class se utilizara desde otra, provider gestiona conexiones con bd
class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._(); //Instancia de la misma

  DBProvider._();

  // ! Estamos seguros obtendra valor
  Future<Database> get database async {
    if (_database == null) return await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db'); //OBTENIR PATH

    //CREAR BBDD
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''CREATE TABLE Scans(id INTEGER PRIMARY KEY, tipus TEXT,valor TEXT)''');
    });
  }

  Future<int> insertScan(ScanModel nouScan) async {
    final db = await database;
    final res = await db.insert('Scans', nouScan.toMap());
    return res;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromMap(res.first) : null;
  }

  Future<List<ScanModel>> getScansByType(String tipus) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipus = ?', whereArgs: [tipus]);

    return res.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<int> updateScan(ScanModel nouScan) async {
    final db = await database;
    final res = db.update('Scans', nouScan.toMap(), where: 'id = ?', whereArgs: [nouScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = db.rawDelete('''DELETE FROM Scans''');
    return res;
  }

/*
  Future<int> insertRawScan(ScanModel nouScan) async {
    final id = nouScan.id;
    final tipus = nouScan.tipus;
    final valor = nouScan.valor;

    final db = await database;
    final res = await db.rawInsert('''INSERT INTO Scan(id,tipus,valor) VALUES ($id, $tipus, $valor)''');
    return res;
  }
  */
}
