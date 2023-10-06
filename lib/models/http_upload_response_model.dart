class HttpUploadResponseModel {
  final bool ok;
  final String message;

  HttpUploadResponseModel({required this.ok, required this.message});

  factory HttpUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      HttpUploadResponseModel(ok: json["ok"], message: json["message"]);
}
