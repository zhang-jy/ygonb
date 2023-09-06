import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:ygonotebook/constant/common_constant.dart';

Future<void> copyDb2DocDir() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, cardDbName);
  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
    ByteData data = await rootBundle.load(join('assets', 'db', cardDbName));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
}

Future<Database> openDb() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String databasePath = join(appDocDir.path, cardDbName);
  final db = sqlite3.open(databasePath);
  return db;
}

Future<ResultSet> cardsDbTables() async {
  final db = await openDb();
  return db.select('SELECT * FROM sqlite_master ORDER BY name;');
}

Future<ResultSet> queryCard1() async {
  final db = await openDb();
  return db.select('SELECT d.id, ot, atk, def, level, name, desc '
      'FROM datas AS d, texts AS t '
      'where d.id = t.id '
      'LIMIT 1;');
}