import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';

class BusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessController>(
      BusinessController.new,
    );
  }
}
