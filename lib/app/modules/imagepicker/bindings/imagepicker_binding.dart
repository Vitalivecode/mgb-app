import 'package:get/get.dart';

import '../controllers/imagepicker_controller.dart';

class ImagepickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagepickerController>(
      () => ImagepickerController(),
    );
  }
}
