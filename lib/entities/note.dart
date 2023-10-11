import 'package:isar/isar.dart';

part 'note.g.dart';

enum SyncDataStatus { sync, pending }

@collection
class Note {
  final Id? isarId;
  final String id;
  final String name;
  final String note;
  final List<String> coordenates;
  final List<String> updatedCoordenates;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  @enumerated
  SyncDataStatus syncState;

  Note({
    required this.isarId,
    required this.id,
    required this.name,
    required this.note,
    required this.coordenates,
    required this.createdAt,
    required this.createdBy,
    required this.syncState,
    this.updatedCoordenates = const [],
    required this.updatedAt,
    this.updatedBy = 0,
  });
}
