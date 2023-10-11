import 'package:apuntes/entities/index.dart';
import 'package:apuntes/mappers/note_mapper.dart';

class HttpUploadRequestModel {
  final List<Note> notes;
  final User? user;

  HttpUploadRequestModel({this.notes = const [], required this.user});

  Map<String, dynamic> modelToRequest() {
    final mappedNotes =
        notes.map((note) => NoteMapper.mapToRequest(note)).toList();
    return {'notas': mappedNotes, 'email': user?.email ?? "email desconocido"};
  }
}
