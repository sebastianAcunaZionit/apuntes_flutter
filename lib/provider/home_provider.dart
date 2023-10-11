import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/datasource/datasources.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<List<Note>> getList(GetListRef ref, [int page = 0]) async {
  final response = await NoteDatasource().findNotes(offset: page);
  return response;
}

@riverpod
class HomeProv extends _$HomeProv {
  final noteRepo = NoteDatasource();
  @override
  Future<HomeState> build() {
    return onLoadData(1);
  }

  Future<HomeState> onLoadData([int page = 0, String? name]) async {
    const limit = 10;
    final offset = (page - 1) * limit;
    final response = await NoteDatasource()
        .findNotes(offset: offset, limit: limit, name: name);

    final total =
        await NoteDatasource().findNotes(offset: 0, limit: null, name: name);

    return HomeState(
      notes: response,
      total: (total.length / limit).ceil(),
      page: page,
      filter: name,
    );
  }

  void changePage(int page) async {
    final historial = await onLoadData(page);
    state = AsyncValue.data(historial);
  }

  void getFilter(String name) async {
    final historial = await onLoadData(1, name);
    state = AsyncValue.data(historial);
  }
}

class HomeState {
  final String errorMessage;
  final int page;
  final int total;
  final List<Note> notes;
  final String? filter;

  HomeState({
    this.errorMessage = "",
    this.page = 0,
    this.total = 0,
    this.notes = const [],
    this.filter,
  });
}
