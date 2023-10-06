import 'package:ygonotebook/model/error.dart';

enum _ListStateEnum {
  loading,
  empty,
  ready,
  error
}

class ListState<T> {

  ListState._(this._type, {this.data, this.error});

  final _ListStateEnum _type;
  final T? data;
  final AppCommonError? error;

  factory ListState.loading() {
    return ListState._(_ListStateEnum.loading);
  }

  factory ListState.empty() {
    return ListState._(_ListStateEnum.empty);
  }

  factory ListState.ready({T? data}) {
    return ListState._(_ListStateEnum.ready, data: data);
  }

  factory ListState.error({AppCommonError? error}) {
    return ListState._(_ListStateEnum.error, error: error);
  }

  R when<R extends Object?>({
    required R Function() loading,
    required R Function() empty,
    required R Function(T? data) ready,
    required R Function(AppCommonError? error) error,
  }) {
    switch(_type) {
      case _ListStateEnum.loading: {
        return loading();
      }
      case _ListStateEnum.empty: {
        return empty();
      }
      case _ListStateEnum.ready: {
        return ready(data);
      }
      case _ListStateEnum.error: {
        return error(this.error);
      }
    }
  }
}