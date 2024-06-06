import 'package:get/get.dart';

import '../controllers/contact_support_controller.dart';

class ContactSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactSupportController>(
      () => ContactSupportController(),
    );
  }
}
