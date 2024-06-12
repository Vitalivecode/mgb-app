import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/contact_support/controllers/contact_support_controller.dart';

class ContactSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactSupportController>(
      ContactSupportController.new,
    );
  }
}
