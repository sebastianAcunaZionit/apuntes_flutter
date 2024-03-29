import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'package:apuntes/datasource/datasources.dart';
import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/provider/providers.dart';

part 'note_provider.g.dart';

@riverpod
class NoteProv extends _$NoteProv {
  @override
  NoteState build() {
    return NoteState();
  }

  loadData(String uid) async {
    final noteRepo = NoteDatasource();
    if (uid == "new") {
      state = state.copyWith(
        id: const Uuid().v4(),
        createdBy: ref.read(authProvider).user?.id ?? 1,
        createdAt: DateTime.timestamp().toString(),
      );
      return;
    }

    final note = await noteRepo.findNoteById(uid);
    if (note == null) {
      print("no se encontro note");
      return;
    }

    ref.watch(noteFormProvider.notifier).controllerName.text = note.name;
    ref.watch(noteFormProvider.notifier).controllerNote.text = note.note;
    ref.watch(noteFormProvider.notifier).onChangeName(note.name);
    ref.watch(noteFormProvider.notifier).onChangeNote(note.note);

    state = state.copyWith(
      isarId: note.isarId,
      id: note.id,
      createdAt: note.createdAt.toString(),
      createdBy: note.createdBy,
      coordenates: note.coordenates,
      name: note.name,
      note: note.note,
    );
  }

  onSave(String name, String note) async {
    final noteRepo = NoteDatasource();
    if (!ref.read(noteFormProvider).isFormValid) return;

    await ref.read(locationProvProvider.notifier).onLocationService();

    final newCoordenates = [
      ref.watch(locationProvProvider).latitude,
      ref.watch(locationProvProvider).longitude
    ];
    final address = ref.watch(locationProvProvider).address;

    final noteLike = Note(
      isarId: state.isarId,
      id: state.id,
      name: name,
      note: note,
      coordenates:
          (state.coordenates.isEmpty) ? newCoordenates : state.coordenates,
      address: (state.address.isEmpty) ? address : state.address,
      updatedCoordenates: newCoordenates,
      updatedAddress: address,
      createdAt: (state.createdAt.isEmpty)
          ? DateTime.now()
          : DateTime.parse(state.createdAt),
      createdBy: state.createdBy,
      syncState: SyncDataStatus.pending,
      updatedAt: DateTime.timestamp(),
      updatedBy: ref.read(authProvider).user?.id ?? 1,
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
  final List<String> updatedCoordenates;
  final String createdAt;
  final int createdBy;
  final String updatedAt;
  final int updatedBy;
  final String address;
  final String updatedAddress;

  NoteState({
    this.isarId,
    this.id = "",
    this.name = "",
    this.note = "",
    this.coordenates = const [],
    this.createdAt = "",
    this.createdBy = 0,
    this.updatedCoordenates = const [],
    this.updatedAt = "",
    this.updatedBy = 0,
    this.address = "",
    this.updatedAddress = "",
  });

  NoteState copyWith({
    Id? isarId,
    String? id,
    String? name,
    String? note,
    List<String>? coordenates,
    String? createdAt,
    int? createdBy,
    List<String>? updatedCoordenates,
    String? updatedAt,
    int? updatedBy,
    String? address,
    String? updatedAddress,
  }) =>
      NoteState(
        isarId: isarId ?? this.isarId,
        id: id ?? this.id,
        name: name ?? this.name,
        note: note ?? this.note,
        coordenates: coordenates ?? this.coordenates,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedCoordenates: updatedCoordenates ?? this.updatedCoordenates,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        address: address ?? this.address,
        updatedAddress: updatedAddress ?? this.updatedAddress,
      );

  @override
  String toString() {
    return """

isarId: $isarId, 
id: $id, 
name: $name, 
note: $note, 
coordenates: $coordenates, 
createdAt: $createdAt, 
createdBy: $createdBy, 
updatedCoordenates: $updatedCoordenates, 
updatedAt: $updatedAt, 
updatedBy: $updatedBy, 
address: $address, 
updatedAddress: $updatedAddress, 


 """;
  }
}
