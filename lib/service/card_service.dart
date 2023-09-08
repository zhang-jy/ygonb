import 'package:ygonotebook/db/card_dao.dart';
import 'package:ygonotebook/model/ygo_card.dart';

class CardService {

  final _cardDao = CardDao();

  Future<YGOCard?> getCardById(int id) async {
    final querySet = await _cardDao.queryCardById(id);
    return YGOCard.fromResultSet(querySet).firstOrNull;
  }

  Future<List<YGOCard>> getCardsLike(String queryText) async {
    final querySet = await _cardDao.queryCardLike(queryText);
    return YGOCard.fromResultSet(querySet);
  }
}
