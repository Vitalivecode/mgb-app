import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/templates/controllers/templates_controller.dart';

class TemplatesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplatesController>(
      TemplatesController.new,
    );
  }
}
