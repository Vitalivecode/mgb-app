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
  String? otp = '';

  // String? cid;
  // String? cPhone;
  // String? aid;

  verify(BuildContext context) async {
    AppUtils.poPup(context);
    final url = Uri.parse(AppUrls.productionHost + AppUrls.verifyotp);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    request.fields['cOTP'] = otp!;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    print(data);
    if (data == 'No Customer') {
      AppUtils.flushbarShow(
        AppColors.red,
        'OTP do not Match, Please Try again',
        context,
      );
    } else if (data == 'null') {
      Get.toNamed(Routes.CREATE_PROFILE);
    } else {
      var details;
      details = jsonDecode(data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('eMail', details['cEmail'].toString());
      prefs.setString('pId', details['pId'].toString());
      MyGalleryBookRepository.setUserName(details as Map<String, dynamic>);
      getmypack();
    }
  }

  getmypack() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      final details = jsonDecode(data);
      if (details[0]['pStatus'] == '1') {
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
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getotp);
    final request = http.MultipartRequest('POST', url);
    request.fields['cPhone'] = MyGalleryBookRepository.getCPhone();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    Get.back();
    AppUtils.flushbarShow(
      AppColors.green,
      'OTP Sent to ${MyGalleryBookRepository.getCPhone()}',
      context,
    );
  }
}
