import 'package:ygonotebook/db/card_dao.dart';
import 'package:ygonotebook/model/ygo_card.dart';

class CardService {

  final _cardDao = CardDao();

  Future<List<String>> getCardsTableColumnName() async {
    final querySet = await _cardDao.showCardsDbTables();
    return querySet.rows.map((e) => "$e").toList();
  }

  Future<String?> queryCardAllColumnById(int id) async {
    final querySet = await _cardDao.queryCardAllColumnById(id);
    return querySet.firstOrNull?.values.map((e) => "{$e}").join(",");
  }

  Future<YGOCard?> getCardById(int id) async {
    final querySet = await _cardDao.queryCardById(id);
    return YGOCard.fromResultSet(querySet).firstOrNull;
  }

  Future<List<YGOCard>> getCardsLike(String queryText) async {
    final querySet = await _cardDao.queryCardLike(queryText);
    return YGOCard.fromResultSet(querySet);
  }

  Future<List<YGOCard>> getCardsPager() async {
    final querySet = await _cardDao.queryCardPager(20, 0);
    return YGOCard.fromResultSet(querySet);
  }
}
