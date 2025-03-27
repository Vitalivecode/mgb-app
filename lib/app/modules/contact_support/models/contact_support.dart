class ContactSupport {
  final String? emailId;
  final String? phoneNo;

  ContactSupport({
    this.emailId,
    this.phoneNo,
  });

  factory ContactSupport.fromJson(Map<String, dynamic> json) => ContactSupport(
        emailId: json["emailId"],
        phoneNo: json["phoneNo"],
      );

  Map<String, dynamic> toJson() => {
        "emailId": emailId,
        "phoneNo": phoneNo,
      };
}
