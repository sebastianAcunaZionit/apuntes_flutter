import 'package:apuntes/entities/entities.dart';

class NoteMapper {
  static Map<String, dynamic> mapToRequest(Note note) {
    return {
      "uid_apunte": note.id,
      "nombre_persona": note.name,
      "desc_apunte": note.note,
      "id_user_crea": note.createdBy,
      "fecha_hora_apunte": note.createdAt.toString(),
      "latitud": (note.coordenates.isNotEmpty) ? note.coordenates[0] : "",
      "longitud": (note.coordenates.length > 1) ? note.coordenates[1] : "",
      "latitud_mod": (note.updatedCoordenates.isNotEmpty)
          ? note.updatedCoordenates[0]
          : "",
      "longitud_mod": (note.updatedCoordenates.length > 1)
          ? note.updatedCoordenates[1]
          : "",
      "fecha_hora_modifica": note.updatedAt.toString(),
      "id_user_mod": note.updatedBy,
      "direccion_orig": note.address,
      "direccion_mod": note.updatedAddress,
    };
  }
}
