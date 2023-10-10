import 'package:apuntes/datasource/note_datasource.dart';
import 'package:apuntes/entities/index.dart';
import 'package:apuntes/provider/auth_provider.dart';
import 'package:apuntes/provider/forms/note_form_provider.dart';
import 'package:apuntes/provider/location_provider.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note_provider.g.dart';

@riverpod
class NoteProv extends _$NoteProv {
  final noteRepo = NoteDatasource();

  @override
  NoteState build() {
    return NoteState();
  }

  onCheckStatus() async {}

  onSave(String name, String note) async {
    await ref.read(locationProvProvider.notifier).onLocationService();

    final noteLike = Note(
      isarId: null,
      id: const Uuid().v4(),
      name: name,
      note: note,
      coordenates: [
        ref.watch(locationProvProvider).latitude,
        ref.watch(locationProvProvider).longitude
      ],
      createdAt: DateTime.timestamp(),
      createdBy: ref.read(authProvider).user?.id ?? 1,
      syncState: SyncState.pending,
    );
    await noteRepo.postNote(noteLike);

    await Future.delayed(const Duration(seconds: 3));
    ref.read(noteFormProvider.notifier).changeStatus(NoteFormStatus.saved);
  }
}

class NoteState {
  final Id? isarId;
  final String id;
  final String name;
  final String note;
  final List<String> coordenates;
  final String createdAt;
  final int createdBy;

  NoteState({
    this.isarId,
    this.id = "",
    this.name = "",
    this.note = "",
    this.coordenates = const [],
    this.createdAt = "",
    this.createdBy = 0,
  });

  NoteState copyWith({
    Id? isarId,
    String? id,
    String? name,
    String? note,
    List<String>? coordenates,
    String? createdAt,
    int? createdBy,
  }) =>
      NoteState(
        isarId: isarId ?? this.isarId,
        id: id ?? this.id,
        name: name ?? this.name,
        note: note ?? this.note,
        coordenates: coordenates ?? this.coordenates,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
      );
}
