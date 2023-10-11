import 'package:apuntes/entities/entities.dart';
import 'package:apuntes/mappers/mappers.dart';

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
