import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/home/controllers/home_controller.dart';
import 'package:mygallerybook/app/modules/login/controllers/login_controller.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:mygallerybook/app/modules/settings/controllers/settings_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      HomeController.new,
    );
    Get.lazyPut<BusinessController>(
      BusinessController.new,
    );
    Get.lazyPut<SettingsController>(
      SettingsController.new,
    );
    Get.lazyPut<OrderDetailsController>(
      OrderDetailsController.new,
    );
    Get.lazyPut<LoginController>(
      LoginController.new,
    );
  }
}
