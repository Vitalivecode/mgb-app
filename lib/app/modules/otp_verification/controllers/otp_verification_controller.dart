import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationController extends GetxController {
  String? otp = "", cid, cPhone, aid;

  verify(BuildContext context) async {
    AppUtils.poPup(context);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.verifyotp);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    request.fields['cOTP'] = otp!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    print(data);
    if (data == "No Customer") {
      AppUtils.flushBarshow(
          "OTP do not Match, Please Try again", context, AppColors.red);
    } else if (data == "null") {
      Get.toNamed(Routes.CREATE_PROFILE);
    } else {
      var details;
      details = jsonDecode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("eMail", details["cEmail"]);
      prefs.setString("pId", details["pId"]);
      MyGalleryBookRepository.setUserName(details);

      getmypack();
    }
  }

  getmypack() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    if (data != "[]") {
      var details = jsonDecode(data);
      if (details[0]["pStatus"] == "1") {
        Get.toNamed(Routes.HOME);
      } else {
        Get.toNamed(Routes.SUBSCRIPTION);
      }
    } else {
      Get.toNamed(Routes.SUBSCRIPTION);
    }
  }

  resendotp(BuildContext context) async {
    AppUtils.poPup(context);
    var url = Uri.parse(AppUrls.productionHost + AppUrls.getotp);
    var request = new http.MultipartRequest("POST", url);
    request.fields['cPhone'] = cPhone!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    if (data != null) {
      Get.back();
      AppUtils.flushBarshow("OTP Sent to $cPhone", context, AppColors.green);
    } else {
      Get.back();
      AppUtils.flushBarshow("Something Went Wrong", context, AppColors.red);
    }
  }
}
