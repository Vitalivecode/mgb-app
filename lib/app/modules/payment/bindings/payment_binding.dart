import 'package:get/get.dart';

import 'package:mygallerybook/app/modules/payment/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
    );
  }
}
