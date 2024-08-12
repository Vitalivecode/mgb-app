import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/create_address/models/profile.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final name = "".obs;
  ProfileModel profile = ProfileModel();
  final RxMap details = RxMap();
  final isLoading = false.obs;

  getName() async {
    final cid = MyGalleryBookRepository.getCId();
    print(cid);
    name.value = details['cFName'] + " " + details['cLName'] ?? " ";
    print(name.value);
    name.refresh();
    update();
  }

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cid');
    prefs.remove('eMail');
    prefs.remove('cPhone');
    Get.offAndToNamed(Routes.LOGIN);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? cid;

  DateTime? current;

  Future<bool> onBackPressed() async {
    final now = DateTime.now();
    if (current == null ||
        now.difference(current!) > const Duration(seconds: 3)) {
      current = now;
      Fluttertoast.showToast(
        msg: 'Press Again to Exit',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: AppColors.black,
        fontSize: 14,
        textColor: Colors.white,
      );
      return Future.value(false);
    } else {
      Fluttertoast.cancel();
      SystemNavigator.pop();
      return true;
    }
  }

  getProfile() async {
    print("getProfile called");
    isLoading.value = true;
    final url = Uri.parse(AppUrls.productionHost + AppUrls.getProfile);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();

    if (data.isEmpty) {
      details.value = {};
      print("there is no data for the get profile");
      isLoading.value = false;
      return;
    }
    details.clear();
    details.assignAll(jsonDecode(data));
    details.value = jsonDecode(data);
    log("${details}user first name and last name in the settings controller we are printing");
    getName();
    isLoading.value = false;
  }

  @override
  void onInit() {
    getProfile();
    print("onInit called");
    super.onInit();
  }
}

// AppUtils.showConfirmationAlert(
//     context: Get.context!,
//     titleText: "Logout",
//     contentText: "Are you sure you want to logout",
//     onConfirm: () async {
//       // SpUtil.clear();
//       final prefs = await SharedPreferences.getInstance();
//       prefs.remove('cid');
//       prefs.remove('eMail');
//       prefs.remove('cPhone');
//       // BusinessController bController = BusinessController();
//       // Get.delete<BusinessController>();
//       // Get.put(BusinessController());
//       // bController.orders.clear();
//       // bController.packs.value.clear();
//       Get.offAndToNamed(Routes.LOGIN);
//     },
//     onCancel: () {
//       Get.back();
//     });
