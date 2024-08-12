import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/core/app_urls.dart';

class AllOrdersController extends GetxController {
  final loading = true.obs;
  final orders = <Map<String, dynamic>>[].obs;
  final error = Rx<String?>(null);
  final oStatus = Rx<String?>(null);

  void getData() async {
    try {
      final url = Uri.parse(AppUrls.productionHost + AppUrls.myOrder);
      final request = http.MultipartRequest("POST", url)
        ..fields['cId'] = MyGalleryBookRepository.getCId();
      final response = await request.send();
      final data = await response.stream.transform(utf8.decoder).join();
      if (data.isNotEmpty) {
        final List<dynamic> jsonData = jsonDecode(data);
        orders.value = jsonData.cast<Map<String, dynamic>>();
        if (orders.isNotEmpty) {
          oStatus.value = orders[0]["oStatus"];
        }
      } else {
        orders.value = [];
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
    print(orders);
  }

  String getStatus(String status) {
    switch (status) {
      case '1':
        return 'Ordered';
      case '2':
        return 'Received';
      case '3':
        return 'Printed';
      case '4':
        return 'Dispatched';
      case '5':
        return 'Delivered';
      default:
        return 'Ordered';
    }
  }

  @override
  void onInit() {
    print("allOrders onInit called");
    getData();
    super.onInit();
  }
}
