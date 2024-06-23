import 'dart:developer';

import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/all_orders/providers/orders_provider.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';

class AllOrdersController extends GetxController {
  final loading = true.obs;
  final error = Rx<String?>(null);
  final oStatus = Rx<String?>(null);
  final orders = <Map>[].obs;

  Future<void> getData() async {
    print("getDataCalled");
    if (loading.isTrue) {
      print("loading isTrue");
      error.value = null;
      loading.value = true;
      try {
        final result = await OrdersProvider.getOrders(
          MyGalleryBookRepository.getCId(),
        );
        log("${result}this is inside the getData");
        orders
          ..clear()
          ..addAll(result as Iterable<Map>);
        if (orders.isNotEmpty) {
          oStatus.value = orders[0]['oStatus']?.toString();
          log("${orders}this is orders data");
        }
      } catch (e) {
        error.value = e.toString();
      }
      loading.value = false;
    }
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
    print("onInitCalled");
    getData();
    log(orders.toString());
    super.onInit();
  }
}
