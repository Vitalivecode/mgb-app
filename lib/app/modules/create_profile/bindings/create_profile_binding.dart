import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/create_profile/controllers/create_profile_controller.dart';

class CreateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateProfileController>(
      CreateProfileController.new,
    );
  }
}
