import 'package:path/path.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:ygonotebook/app/init.dart';

class YGOCard {
  final int id;
  final int ot;
  final int _atk;
  final int _def;
  final int level;
  final String name;
  final String desc;
  final String? _localImageUrl;
  final String? _networkImageUrl;

  String get localImageUrl => (_localImageUrl == null || _localImageUrl!.isEmpty) ? join(localImagePath, "177x254", "$id.jpg") : _localImageUrl!;
  String get networkImageUrl => _networkImageUrl ?? "";

  String get atk {
    if (_atk == -2) {
      return "?";
    }
    return "$_atk";
  }

  String get def {
    if (_def == -2) {
      return "?";
    }
    return "$_def";
  }

  YGOCard(this.id, this.ot, int atk, int def, this.level, this.name, this.desc,
      {String? localImageUrl, String? networkImageUrl})
      : _localImageUrl = localImageUrl, _networkImageUrl = networkImageUrl,
        _atk = atk, _def = def;

  factory YGOCard.fromRow(sqlite3.Row row) {
    return YGOCard(row["id"], row["ot"], row["atk"], row["def"], row["level"],
        row["name"], row["desc"]);
  }

  static List<YGOCard> fromResultSet(ResultSet resultSet) {
    return [...resultSet.map((e) => YGOCard.fromRow(e))];
  }

  @override
  String toString() {
    return 'YGOCard{id: $id, ot: $ot, atk: $atk, def: $def, level: $level, name: $name, desc: $desc, localUrl: $localImageUrl, networkUrl: $networkImageUrl}';
  }
}