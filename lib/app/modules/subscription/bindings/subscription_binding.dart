import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/payment/controllers/payment_controller.dart';

import '../controllers/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(
      () => SubscriptionController(),
    );
    Get.lazyPut<PaymentController>(
          () => PaymentController(),
    );
  }
}
