import 'package:get/get.dart';

import '../controllers/reupload_images_controller.dart';

class ReuploadImagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReuploadImagesController>(
      () => ReuploadImagesController(),
    );
  }
}
