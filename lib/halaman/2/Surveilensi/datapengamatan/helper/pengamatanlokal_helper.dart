import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/tahapan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PengamatanHelper {
  static final PengamatanHelper instance = PengamatanHelper._init();
  static Database? _database;

  PengamatanHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pengamatan_app');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pengamatan_app');
    return await openDatabase(
      path,
      version: 9,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE pengamatan ADD COLUMN lahanId TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE pengamatan ADD COLUMN namaOPT TEXT');
          await db.execute('ALTER TABLE pengamatan ADD COLUMN metodePengamatan TEXT');
          await db.execute('ALTER TABLE pengamatan ADD COLUMN jumlahKotak INTEGER');
        }
        if (oldVersion < 4) {
          await db.execute('''
          CREATE TABLE statuspetak (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_pengamatan_lokal INTEGER NOT NULL,
            index_petak INTEGER NOT NULL,
            sudah_diisi INTEGER NOT NULL DEFAULT 0,
            -- data_petak_json TEXT, 
            FOREIGN KEY (id_pengamatan_lokal) REFERENCES pengamatan (id) ON DELETE CASCADE,
            UNIQUE (id_pengamatan_lokal, index_petak)
          )
          ''');
        }
        if (oldVersion < 5) {
          await db.execute('ALTER TABLE pengamatan ADD COLUMN targetPanen TEXT');
        }
        if (oldVersion < 7) {
          await db.execute('ALTER TABLE pengamatan ADD COLUMN insidensi REAL');
          await db.execute('ALTER TABLE pengamatan ADD COLUMN severity REAL');
        }
        if (oldVersion < 8) {
          await db.execute('ALTER TABLE pengamatan ADD COLUMN dokURL TEXT');
        }
      }
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE pengamatan (
      id $idType,
      lahanId TEXT,
      docId $textType,
      judul $textType,
      tanggal $textType,
      namaOPT TEXT,
      dokURL TEXT,
      metodePengamatan TEXT,
      jumlahKotak INTEGER,
      targetPanen TEXT,
      insidensi REAL,
      severity REAL
    )
    ''');

    await db.execute('''
    CREATE TABLE tahapan (
      id $idType,
      id_pengamatan $integerType,
      nama_tahapan $textType,
      status $textType DEFAULT 'Belum Selesai',
      urutan $integerType,
      FOREIGN KEY (id_pengamatan) REFERENCES pengamatan (id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE statuspetak (
      id $idType,
      id_pengamatan_lokal $integerType,
      index_petak $integerType,
      sudah_diisi $integerType,
      FOREIGN KEY (id_pengamatan_lokal) REFERENCES pengamatan (id) ON DELETE CASCADE,
      UNIQUE (id_pengamatan_lokal, index_petak)
    )
    ''');
  }

  Future<int> tambahPengamatan(PengamatanLokal pengamatan) async {
    final db = await database;
    return await db.insert('pengamatan', pengamatan.toMap());
  }

  Future<int> updateInsidensiSeverity(int id, double insidensi, double severity) async {
  final db = await database;
  return await db.update(
    'pengamatan',
    {
      'insidensi': insidensi,
      'severity': severity,
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}

  Future<List<PengamatanLokal>> fetchPengamatanList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pengamatan');
    return List.generate(maps.length, (i) => PengamatanLokal.fromMap(maps[i]));
  }

  Future<List<PengamatanLokal>> getPengamatanByLahanId(String lahanId) async {
    final db = await database;
    // final dbPath = await getDatabasesPath();
    // await deleteDatabase(join(dbPath, 'pengamatan_app'));
    final List<Map<String, dynamic>> maps = await db.query(
      'pengamatan',
      where: 'lahanId = ?',
      whereArgs: [lahanId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => PengamatanLokal.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<PengamatanLokal?> getPengamatanbyId(int id) async {
    final db = await database;
    final maps = await db.query(
      'pengamatan',
      where: 'id = ?' ,
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return PengamatanLokal.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePengamatan(int id) async {
    final db = await database;
    return await db.delete('pengamatan', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePengamatan(PengamatanLokal pengamatan) async {
    final db = await database;
    return await db.update('pengamatan', pengamatan.toMap(), where: 'id = ?', whereArgs: [pengamatan.id]);
  }

  // CRUD BUAT TAHAPANNYA
  Future<int> insertTahapan(TahapanModel tahapan) async {
    final db = await instance.database;
    return await db.insert('tahapan', tahapan.toMap());
  }

  Future<List<TahapanModel>> getTahapanByPengamatanId(int idPengamatan) async {
    final db = await instance.database;
    final maps = await db.query(
      'tahapan',
      where: 'id_pengamatan = ?',
      whereArgs: [idPengamatan],
      orderBy: 'urutan ASC',
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => TahapanModel.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<int> updateTahapan(TahapanModel tahapan) async {
    final db = await instance.database;
    return await db.update(
      'tahapan',
      tahapan.toMap(),
      where: 'id = ?',
      whereArgs: [tahapan.id],
    );
  }

  Future<int> deleteTahapan(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tahapan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // JAGA-JAGA MISAL BUTUH
  Future<int> deleteSemuaTahapan(int idPengamatan) async {
    final db = await instance.database;
    return await db.delete(
      'tahapan',
      where: 'id_pengamatan = ?',
      whereArgs: [idPengamatan]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> deleteDatabaseForTesting() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pengamatan_app');
    await deleteDatabase(path);
    _database = null;
  }

  // CURD UNTUK STATUS PETAK
  Future<void> setStatusPetak(
      int idPengamatanLokal, int indexPetak, bool sudahDiisi,
      {String? dataModelJson}) async {
    final db = await database;
    Map<String, dynamic> row = {
      'id_pengamatan_lokal': idPengamatanLokal,
      'index_petak': indexPetak,
      'sudah_diisi': sudahDiisi ? 1 : 0,
    };
    await db.insert(
      'statuspetak',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Set<int>> getIndeksPetakTerisi(int idPengamatanLokal) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'statuspetak',
    where: 'id_pengamatan_lokal = ? AND sudah_diisi = ?',
    whereArgs: [idPengamatanLokal, 1],
    columns: ['index_petak'], // Hanya ambil kolom index_petak
  );

  Set<int> terisiSet = {};
  for (var map in maps) {
    terisiSet.add(map['index_petak'] as int);
  }
  return terisiSet;
}
  
  Future<void> deleteStatusPetakUntukPengamatan(int idPengamatanLokal) async {
    final db = await database;
    await db.delete(
      'statuspetak',
      where: 'id_pengamatan_lokal = ?',
      whereArgs: [idPengamatanLokal],
    );
  }
}