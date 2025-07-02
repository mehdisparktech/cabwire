class UpdateStatusRequestModel {
  final bool isOnline;

  UpdateStatusRequestModel({required this.isOnline});

  Map<String, dynamic> toJson() {
    return {'isOnline': isOnline};
  }

  factory UpdateStatusRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateStatusRequestModel(isOnline: json['isOnline'] as bool);
  }
}
