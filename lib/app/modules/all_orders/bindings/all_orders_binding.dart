import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/all_orders/controllers/all_orders_controller.dart';

class AllOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllOrdersController>(AllOrdersController.new);
  }
}
