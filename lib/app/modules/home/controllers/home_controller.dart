import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  late String cid;
  late String pack = '0';

  var packs;

  updateid(String id) {
    cid = id;
    print(cid);
    myPack();
  }

  myPack() async {
    final url = Uri.parse(AppUrls.productionHost + AppUrls.myPacks);
    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = cid;
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    if (data != '[]') {
      packs = jsonDecode(data);
      pack = packs[packs.length - 1]['sRemainAlbums'].toString();
      print(pack);
    }
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
}
