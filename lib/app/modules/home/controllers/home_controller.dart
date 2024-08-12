import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';

class HomeController extends GetxController {
  final date = Rx<String?>(null);
  final expireDate = Rx<String?>(null);
  final currentIndex = 0.obs;
  final subscriptionEndedDate = Rx<int?>(0);
  late String pack = '0';
  Rx<List<dynamic>> packs = Rx<List<dynamic>>([]);

  void days() {
    final date1 = DateTime.now();
    final date2 = DateTime.parse('${expireDate.value}');
    final differenceInDays = date2.difference(date1).inDays;
    date.value = (differenceInDays / 30).round().toString();
    subscriptionEndedDate.value = int.tryParse(date.value ?? '0');
    print(
        "${subscriptionEndedDate.value}this is the subscription Ended month in the home controller");
  }

  Future<List<dynamic>?> myPack() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    final response = await request.send();
    final data1 = await response.stream.transform(utf8.decoder).join();
    final data = jsonDecode(data1)[0];
    if (data != '[]') {
      try {
        packs.value = RxList.of(jsonDecode(data1)) as List<dynamic>;
        log("${packs.value}this is for checking");
        expireDate.value = packs.value[packs.value.length - 1]['sEndDate']
            .split(' ')[0]
            .toString();
        days();
        packs.refresh();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        debugPrint(e.toString());
      }
    } else {
      packs.value = [];
      packs.refresh();
    }
    return null;
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    final now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Again to Exit',
        backgroundColor: AppColors.darkBlue,
        textColor: AppColors.white,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void onInit() {
    myPack();
    packs.refresh();
    super.onInit();
  }
}
