import 'package:get/get.dart';

import '../controllers/business_controller.dart';

class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessController>(
      () => BusinessController(),
    );
  }
}
