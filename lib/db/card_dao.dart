import 'package:sqlite3/common.dart';
import 'package:ygonotebook/util/db_util.dart';

class CardDao {

  /// 查询表结构
  Future<ResultSet> showCardsDbTables() async {
    final db = await openDb();
    return db.select('SELECT * FROM sqlite_master ORDER BY name;');
  }

  /// 通过id查询卡片全部字段
  Future<ResultSet> queryCardAllColumnById(int id) async {
    final db = await openDb();
    return db.select('SELECT * '
        'FROM datas AS d, texts AS t '
        'where d.id = ? AND d.id = t.id '
        'LIMIT 1;', ['$id']);
  }

  /// 通过id查询卡片
  Future<ResultSet> queryCardById(int id) async {
    final db = await openDb();
    return db.select('SELECT d.id, ot, atk, def, level, name, desc '
        'FROM datas AS d, texts AS t '
        'where d.id = ? AND d.id = t.id '
        'LIMIT 1;', ['$id']);
  }

  /// 通过名字模糊查询卡片
  Future<ResultSet> queryCardLike(String queryText) async {
    final db = await openDb();
    return db.select('SELECT d.id, ot, atk, def, level, name, desc '
        'FROM datas AS d, texts AS t '
        'where name LIKE ? AND d.id = t.id '
        'LIMIT 1;', ['%$queryText%']);
  }

  /// 通过名字模糊查询卡片
  Future<ResultSet> queryCardPager(int pageSize, int start, {String? queryText}) async {
    final db = await openDb();
    final whereCondition = queryText == null || queryText.isEmpty
        ? 'where d.id = t.id '
        : 'where name LIKE ? AND d.id = t.id ';
    final args = queryText == null || queryText.isEmpty
        ? ['$pageSize', '$start']
        : ['%$queryText%', '$pageSize', '$start'];
    return db.select('SELECT d.id, ot, atk, def, level, name, desc '
        'FROM datas AS d, texts AS t $whereCondition'
        'LIMIT ? OFFSET ?;', args);
  }
}