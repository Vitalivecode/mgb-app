import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsController>(
      OrderDetailsController.new,
    );
  }
}
