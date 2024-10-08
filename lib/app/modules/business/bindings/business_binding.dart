import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/all_orders/controllers/all_orders_controller.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';

class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessController>(
      BusinessController.new,
    );
    Get.lazyPut<AllOrdersController>(
      AllOrdersController.new,
    );
    Get.lazyPut<OrderDetailsController>(
      OrderDetailsController.new,
    );
  }
}
