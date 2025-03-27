class CustomerAddress {
  final String? aId;
  final String? cId;
  final String? cDoorNo;
  final String? cStreet;
  final String? cLandMark;
  final String? cCity;
  final String? cPincode;

  CustomerAddress({
    this.aId,
    this.cId,
    this.cDoorNo,
    this.cStreet,
    this.cLandMark,
    this.cCity,
    this.cPincode,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
        aId: json["aId"],
        cId: json["cId"],
        cDoorNo: json["cDoorNo"],
        cStreet: json["cStreet"],
        cLandMark: json["cLandMark"],
        cCity: json["cCity"],
        cPincode: json["cPincode"],
      );

  Map<String, dynamic> toJson() => {
        "aId": aId,
        "cId": cId,
        "cDoorNo": cDoorNo,
        "cStreet": cStreet,
        "cLandMark": cLandMark,
        "cCity": cCity,
        "cPincode": cPincode,
      };
}
