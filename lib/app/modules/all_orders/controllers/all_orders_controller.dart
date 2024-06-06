import 'dart:convert';

import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:http/http.dart'as http;

class AllOrdersController extends GetxController {
  String? cid, oStatus;
  var orders;
  bool loading = true;
  updateid(String? id) async {
      cid = id;
      myOrders();
  }
  myOrders() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
    var request = http.MultipartRequest("POST", url);
    request.fields['cId'] = cid!;
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    if (data != "[]") {
        orders = jsonDecode(data);
        oStatus = orders[0]["oStatus"];
    } else {
        orders = null;
    }
      loading = false;
    print(orders);
  }
  getStatus(status) {
    switch (status) {
      case "1":
        return "Ordered";
      case "2":
        return "Received";
      case "3":
        return "Printed";
      case "4":
        return "Dispatched";
      case "5":
        return "Delivered";
      default:
        return "Ordered";
    }
  }
  @override
  void onInit() {
    MyGalleryBookRepository.getCId().then(updateid);
    super.onInit();
  }
}
