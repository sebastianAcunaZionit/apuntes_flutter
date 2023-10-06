import 'package:isar/isar.dart';

part 'note.g.dart';

enum SyncState { sync, pending }

@collection
class Note {
  final Id? isarId;
  final String id;
  final String name;
  final String note;
  final List<String> coordenates;
  final DateTime createdAt;
  final int createdBy;
  @enumerated
  final SyncState syncState;

  Note({
    required this.isarId,
    required this.id,
    required this.name,
    required this.note,
    required this.coordenates,
    required this.createdAt,
    required this.createdBy,
    required this.syncState,
  });
}
