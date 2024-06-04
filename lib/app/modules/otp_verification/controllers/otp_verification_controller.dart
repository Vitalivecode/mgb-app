import 'dart:convert';

import 'package:get/get.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationController extends GetxController {
  String? otp="",cid,cPhone,aid;
  verify() async {
    // poPup(context);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.verifyotp);
    var request =  http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    request.fields['cOTP'] = otp!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    print(data);
    if (data == "No Customer") {
      // Navigator.of(context).pop(true);
      // flushBarshow("OTP do not Match, Please Try again", context, red);
    } else if (data == "null") {
      // Navigator.of(context).pushReplacement(createprofileroute());
    } else {
      var details;
      // setState(() {
      //   details = jsonDecode(data);
      // });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("eMail", details["cEmail"]);
      prefs.setString("pId", details["pId"]);
      // setUserName(details);

      // getmypack();
    }
  }
  resendotp() async {
    // poPup(context);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.getotp);
    var request = new http.MultipartRequest("POST", url);
    request.fields['cPhone'] = cPhone!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    if (data != null) {
      // Navigator.of(context).pop(true);
      // flushBarshow("OTP Sent to $cphone", context, green);
    } else {
      // Navigator.of(context).pop(true);
      // flushBarshow("Something Went Wrong", context, red);
    }
  }
}
