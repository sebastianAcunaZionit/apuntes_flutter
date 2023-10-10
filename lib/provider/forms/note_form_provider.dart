import 'package:apuntes/provider/validations/string_form.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'note_form_provider.g.dart';

enum NoteFormStatus { saving, saved, none }

@riverpod
class NoteForm extends _$NoteForm {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerNote = TextEditingController();

  @override
  NoteFormState build() {
    return NoteFormState();
  }

  Map<String, dynamic>? onSubmit() {
    state = state.copyWith(status: NoteFormStatus.saving);
    _validate();
    if (!state.isFormValid) {
      state = state.copyWith(status: NoteFormStatus.none);
      return null;
    }

    return {'name': state.name.value, 'note': state.note.value};
  }

  changeStatus(NoteFormStatus status) {
    state = state.copyWith(status: status);
  }

  _validate() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      StringInput.dirty(state.name.value),
      StringInput.dirty(state.note.value),
    ]));
  }

  onChangeName(String value) {
    state = state.copyWith(
      name: StringInput.dirty(value),
      isFormValid: Formz.validate([
        StringInput.dirty(value),
        StringInput.dirty(state.note.value),
      ]),
    );
  }

  onChangeNote(String value) {
    state = state.copyWith(
      note: StringInput.dirty(value),
      isFormValid: Formz.validate([
        StringInput.dirty(value),
        StringInput.dirty(state.name.value),
      ]),
    );
  }
}

class NoteFormState {
  final StringInput name;
  final StringInput note;
  final bool isFormValid;
  final String errorMessage;
  final NoteFormStatus status;

  NoteFormState({
    this.name = const StringInput.pure(),
    this.note = const StringInput.pure(),
    this.isFormValid = true,
    this.errorMessage = "",
    this.status = NoteFormStatus.none,
  });

  NoteFormState copyWith({
    StringInput? name,
    StringInput? note,
    List<String>? coordenates,
    bool? isFormValid,
    String? errorMessage,
    NoteFormStatus? status,
  }) =>
      NoteFormState(
        name: name ?? this.name,
        note: note ?? this.note,
        isFormValid: isFormValid ?? this.isFormValid,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
      );
}
