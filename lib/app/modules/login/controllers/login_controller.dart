import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final phoneNumber = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Number shouldnot be empty';
    } else if (value.length != 10) {
      return 'Enter 10 digit Valid Phone Number';
    } else if (double.parse(phoneNumber.text[0]) < 6) {
      return 'Enter Valid Phone Number';
    }
    return null;
  }

  Future<void> check(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Get.dialog(
        AppUtils.loadingOverlay,
        barrierDismissible: false,
      );
      sendOtp();
    }
  }

  void sendOtp() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getotp);
    final request = http.MultipartRequest('POST', url);
    request.fields['cPhone'] = phoneNumber.text;
    final response = await request.send();
    print('response/otp is $response');
    final data = await response.stream.transform(utf8.decoder).join();
    print('data/otp is $data');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cPhone', phoneNumber.text);
    prefs.setString('cid', data);
    phoneNumber.clear();
    Get.back();
    Get.toNamed(Routes.OTP_VERIFICATION);
  }
}
