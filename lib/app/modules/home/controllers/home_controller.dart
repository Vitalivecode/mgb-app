import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/views/business_view.dart';
import 'package:mygallerybook/app/modules/settings/views/settings_view.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/core/app_urls.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  final List<Widget> screens = [
    const BusinessView(),
    const SettingsView(),
  ];
  late String cid, pack = "0";

  var packs;

  updateid(String id) {
      cid = id;
      print(cid);
      myPack();
  }

  myPack() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    var request = new http.MultipartRequest("POST", url);
    request.fields['cId'] = cid;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    if (data != "[]") {
        packs = jsonDecode(data);
        pack = packs[packs.length - 1]["sRemainAlbums"];
        print(pack);
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press Again to Exit",
          backgroundColor: AppColors.darkBlue,
          textColor: AppColors.white,
          gravity: ToastGravity.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
