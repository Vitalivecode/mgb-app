class Order {
  final String oId;
  final String cId;
  final String aId;
  final String pId;
  final String albumId;
  final String oStatus;
  final DateTime orderAt;
  final DateTime modifiedAt;
  final int nofoImages;
  final List<String> uploadImages;
  final dynamic feedback;

  Order({
    required this.oId,
    required this.cId,
    required this.aId,
    required this.pId,
    required this.albumId,
    required this.oStatus,
    required this.orderAt,
    required this.modifiedAt,
    required this.nofoImages,
    required this.uploadImages,
    required this.feedback,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        oId: json["oId"],
        cId: json["cId"],
        aId: json["aId"],
        pId: json["pId"],
        albumId: json["albumId"],
        oStatus: json["oStatus"],
        orderAt: DateTime.parse(json["orderAt"]),
        modifiedAt: DateTime.parse(json["modifiedAt"]),
        nofoImages: json["NofoImages"],
        uploadImages: List<String>.from(json["UploadImages"].map((x) => x)),
        feedback: json["feedback"],
      );

  Map<String, dynamic> toJson() => {
        "oId": oId,
        "cId": cId,
        "aId": aId,
        "pId": pId,
        "albumId": albumId,
        "oStatus": oStatus,
        "orderAt": orderAt.toIso8601String(),
        "modifiedAt": modifiedAt.toIso8601String(),
        "NofoImages": nofoImages,
        "UploadImages": List<dynamic>.from(uploadImages.map((x) => x)),
        "feedback": feedback,
      };
}
