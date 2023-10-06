import 'package:apuntes/entities/index.dart';

class NoteMapper {
  static Map<String, dynamic> mapToRequest(Note note) {
    return {
      "uid_apunte": note.id,
      "nombre_persona": note.name,
      "desc_apunte": note.note,
      "id_user_crea": note.createdBy,
      "fecha_hora_apunte": note.createdAt.toString(),
      "latitud": "",
      "longitud": "",
      "latitud_mod": "",
      "longitud_mod": "",
    };
  }
}
