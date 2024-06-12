import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/payment_history/controllers/payment_history_controller.dart';

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentHistoryController>(
      PaymentHistoryController.new,
    );
  }
}
