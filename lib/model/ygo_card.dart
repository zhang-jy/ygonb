import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

class YGOCard {
  final int id;
  final int ot;
  final int atk;
  final int def;
  final int level;
  final String name;
  final String desc;

  YGOCard(this.id, this.ot, this.atk, this.def, this.level, this.name, this.desc);

  factory YGOCard.fromRow(sqlite3.Row row) {
    return YGOCard(row["id"], row["ot"], row["atk"], row["def"], row["level"],
        row["name"], row["desc"]);
  }

  static List<YGOCard> fromResultSet(ResultSet resultSet) {
    return [...resultSet.map((e) => YGOCard.fromRow(e))];
  }

  @override
  String toString() {
    return 'YGOCard{id: $id, ot: $ot, atk: $atk, def: $def, level: $level, '
        'name: $name, desc: $desc}';
  }
}