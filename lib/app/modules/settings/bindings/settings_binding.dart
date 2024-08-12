import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/profile/controllers/profile_controller.dart';
import 'package:mygallerybook/app/modules/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      SettingsController.new,
    );
    Get.lazyPut<ProfileController>(
      ProfileController.new,
    );
  }
}
