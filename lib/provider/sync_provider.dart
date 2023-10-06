import 'package:apuntes/datasource/note_datasource.dart';
import 'package:apuntes/entities/index.dart';
import 'package:apuntes/errors/custom_error.dart';
import 'package:apuntes/models/http_upload_request_model.dart';
import 'package:apuntes/services/apis/subir_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_provider.g.dart';

@riverpod
class SyncProv extends _$SyncProv {
  final uploadData = UploadData();
  final noteRepo = NoteDatasource();

  @override
  SyncState build() {
    return SyncState();
  }

  void startUpload() async {
    state = state.copyWith(syncStatus: SyncStatus.uploading);
    await Future.delayed(const Duration(seconds: 1));
    try {
      final notes = await noteRepo.findNotesToSync();

      final response = await uploadData.uploadData(HttpUploadRequestModel(
          notes: notes,
          user: User(
              isarId: null,
              id: 0,
              fullName: "",
              userName: "",
              email: "sacuna@zionit.cl")));

      if (!response.ok) {
        state = state.copyWith(
            errorMessage: response.message, syncStatus: SyncStatus.errored);
        return;
      }

      // ! updatear registros subidos
      state = state.copyWith(
          errorMessage: response.message, syncStatus: SyncStatus.uploaded);
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(errorMessage: "", syncStatus: SyncStatus.none);
    } on CustomError catch (e) {
      state = state.copyWith(
          syncStatus: SyncStatus.errored, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
          syncStatus: SyncStatus.errored, errorMessage: "Error no controlado");
    }
  }

  void startDownload() async {
    state = state.copyWith(syncStatus: SyncStatus.downloading);
  }
}

enum SyncStatus { none, uploading, uploaded, downloading, donwloaded, errored }

class SyncState {
  final String errorMessage;
  final SyncStatus syncStatus;

  SyncState({
    this.errorMessage = "",
    this.syncStatus = SyncStatus.none,
  });

  SyncState copyWith({
    String? errorMessage,
    SyncStatus? syncStatus,
  }) =>
      SyncState(
        errorMessage: errorMessage ?? this.errorMessage,
        syncStatus: syncStatus ?? this.syncStatus,
      );
}
