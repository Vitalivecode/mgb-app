import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/imagepicker/controllers/imagepicker_controller.dart';

class ImagepickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagepickerController>(
      ImagepickerController.new,
    );
  }
}
