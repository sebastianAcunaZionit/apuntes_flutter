import 'package:apuntes/datasource/note_datasource.dart';
import 'package:apuntes/entities/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
FutureOr<List<Note>> getList(GetListRef ref, [int page = 0]) async {
  final response = await NoteDatasource().findNotes();
  return response;
}

@riverpod
class HomeProv extends _$HomeProv {
  final noteRepo = NoteDatasource();
  @override
  HomeState build() {
    return HomeState();
  }

  AsyncValue<List<Note>> getNotes([int page = 1]) {
    final response = ref.watch(getListProvider(page));
    return response;
  }
}

class HomeState {
  final String errorMessage;
  final int page;
  final int total;
  final List<Note> notes;

  HomeState({
    this.errorMessage = "",
    this.page = 0,
    this.total = 0,
    this.notes = const [],
  });
}
