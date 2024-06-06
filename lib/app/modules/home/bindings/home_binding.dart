import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/settings/controllers/settings_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<BusinessController>(
      () => BusinessController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
