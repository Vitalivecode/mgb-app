import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final phoneNumber = TextEditingController();

  check(BuildContext context) async {
    if (phoneNumber.text == "") {
      AppUtils.flushBarshow("Enter Phone Number", context, AppColors.red);
    } else if (phoneNumber.text.length != 10) {
      AppUtils.flushBarshow(
          "Enter 10 Digit Valid Phone Number", context, AppColors.red);
    } else if (double.parse(phoneNumber.text[0]) < 6) {
      AppUtils.flushBarshow("Enter Valid Phone Number", context, AppColors.red);
    } else {
      AppUtils.poPup(context);
      sendotp();
    }
  }

  sendotp() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.getotp);
    var request = http.MultipartRequest("POST", url);
    request.fields['cPhone'] = phoneNumber.text;
    var response = await request.send();
    print("response/otp is $response");
    var data = await response.stream.transform(utf8.decoder).join();
    print("data/otp is $data");
    if (data != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("cPhone", phoneNumber.text);
      prefs.setString("cid", data);
      Get.toNamed(Routes.OTP_VERIFICATION);
    } else {
      Get.back();
    }
  }
}
