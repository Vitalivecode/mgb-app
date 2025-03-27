class MySubscriptionPack {
  final String? pId;
  final String? cId;
  final String? sId;
  final DateTime? sEndDate;
  final String? sRemainAlbums;
  final String? amountPaid;
  final String? transactionId;
  final String? pStatus;
  final DateTime? paymentAt;
  final String? sName;
  final String? sMonths;
  final String? sAlbums;
  final String? sCost;
  final String? sOfferCost;
  final String? sStatus;
  final String? sDescription;
  final DateTime? createdAt;
  final DateTime? modifiedAt;

  MySubscriptionPack({
    this.pId,
    this.cId,
    this.sId,
    this.sEndDate,
    this.sRemainAlbums,
    this.amountPaid,
    this.transactionId,
    this.pStatus,
    this.paymentAt,
    this.sName,
    this.sMonths,
    this.sAlbums,
    this.sCost,
    this.sOfferCost,
    this.sStatus,
    this.sDescription,
    this.createdAt,
    this.modifiedAt,
  });

  factory MySubscriptionPack.fromJson(Map<String, dynamic> json) =>
      MySubscriptionPack(
        pId: json["pId"],
        cId: json["cId"],
        sId: json["sId"],
        sEndDate:
            json["sEndDate"] == null ? null : DateTime.parse(json["sEndDate"]),
        sRemainAlbums: json["sRemainAlbums"],
        amountPaid: json["amountPaid"],
        transactionId: json["transactionID"],
        pStatus: json["pStatus"],
        paymentAt: json["paymentAt"] == null
            ? null
            : DateTime.parse(json["paymentAt"]),
        sName: json["sName"],
        sMonths: json["sMonths"],
        sAlbums: json["sAlbums"],
        sCost: json["sCost"],
        sOfferCost: json["sOfferCost"],
        sStatus: json["sStatus"],
        sDescription: json["sDescription"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        modifiedAt: json["modifiedAt"] == null
            ? null
            : DateTime.parse(json["modifiedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "pId": pId,
        "cId": cId,
        "sId": sId,
        "sEndDate": sEndDate?.toIso8601String(),
        "sRemainAlbums": sRemainAlbums,
        "amountPaid": amountPaid,
        "transactionID": transactionId,
        "pStatus": pStatus,
        "paymentAt": paymentAt?.toIso8601String(),
        "sName": sName,
        "sMonths": sMonths,
        "sAlbums": sAlbums,
        "sCost": sCost,
        "sOfferCost": sOfferCost,
        "sStatus": sStatus,
        "sDescription": sDescription,
        "createdAt": createdAt?.toIso8601String(),
        "modifiedAt": modifiedAt?.toIso8601String(),
      };
}
