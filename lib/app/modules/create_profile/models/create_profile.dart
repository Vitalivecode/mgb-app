class CreateProfile {
  final String? pId;
  final String? cId;
  final String? cFName;
  final String? cLName;
  final String? cGender;
  final String? cEmail;
  final String? cPicture;

  CreateProfile({
    this.pId,
    this.cId,
    this.cFName,
    this.cLName,
    this.cGender,
    this.cEmail,
    this.cPicture,
  });

  factory CreateProfile.fromJson(Map<String, dynamic> json) => CreateProfile(
        pId: json["pId"],
        cId: json["cId"],
        cFName: json["cFName"],
        cLName: json["cLName"],
        cGender: json["cGender"],
        cEmail: json["cEmail"],
        cPicture: json["cPicture"],
      );

  Map<String, dynamic> toJson() => {
        "pId": pId,
        "cId": cId,
        "cFName": cFName,
        "cLName": cLName,
        "cGender": cGender,
        "cEmail": cEmail,
        "cPicture": cPicture,
      };
}
