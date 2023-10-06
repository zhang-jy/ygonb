import 'dart:math';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ygonotebook/model/error.dart';
import 'package:ygonotebook/model/list_state.dart';
import 'package:ygonotebook/model/ygo_card.dart';
import 'package:ygonotebook/service/card_service.dart';

final apiProvider = Provider((ref) => CardService());

final cardListProvider = StateNotifierProvider<
    CardListStateNotifier<YGOCard>,
    ListState<List<YGOCard>>>((ref) {
  final api = ref.watch(apiProvider);
  return CardListStateNotifier(
    pageIndex: 1,
    pageSize: 20,
    fetchItems: (int pageIndex, int pageSize) {
      final int pageStart = max(0, pageIndex - 1) * pageSize;
      return api.getCardsPager(pageSize, pageStart);
    }
  );
});

typedef ToastFunction = void Function(String tip);

class CardListStateNotifier<T>
    extends StateNotifier<ListState<List<T>>> {

  CardListStateNotifier({
    required this.fetchItems,
    this.pageSize = 10,
    this.pageIndex = 1,
  }) : super(ListState.loading()) {
    init();
  }
  final EasyRefreshController _refreshController = EasyRefreshController();

  EasyRefreshController get refreshController => _refreshController;

  final Future<List<T>> Function(int pageIndex, int pageSize) fetchItems;

  int _page = 0;
  int pageSize = 10;
  int pageIndex = 1;
  List<T> _items = [];

  void init() {
    firstLoadPage();
  }

  Future<void> firstLoadPage() async {
    _page = pageIndex;
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isEmpty) {
        state = ListState.empty();
      } else {
        _items = list;
        state = ListState.ready(data: list);
      }
      _refreshController.finishRefresh(
          success: true, noMore: list.length < pageSize);
      _refreshController.resetLoadState();
      _page += 1;
    } catch (e) {
      state = ListState.error(error: AppCommonError(errorMsg: e.toString()));
    }
  }

  Future<void> refreshData({ToastFunction? fnToast}) async {
    _page = pageIndex;
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isEmpty) {
        state = ListState.empty();
      } else {
        _items = list;
        state = ListState.ready(data: list);
      }
      _refreshController.finishRefresh(
          success: true, noMore: list.length < pageSize);
      _refreshController.resetLoadState();
      _page += 1;
    } catch (e) {
      _refreshController.finishRefresh(success: false);
      if (fnToast != null) {
        fnToast(e.toString());
      }
      state = ListState.error(error: AppCommonError(errorMsg: e.toString()));
    }
  }

  Future<void> loadMore({ToastFunction? fnToast}) async {
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isNotEmpty) {
        _items.addAll(list);
        state = ListState.ready(data: _items);
      }
      _refreshController.finishLoad(
          success: true, noMore: list.length < pageSize);
      _page += 1;
    } catch (e) {
      _refreshController.finishLoad(success: false);
      state = ListState.error(error: AppCommonError(errorMsg: e.toString()));
      if (fnToast != null) {
        fnToast(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

}