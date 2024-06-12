import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/create_address/controllers/create_address_controller.dart';

class CreateAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAddressController>(
      CreateAddressController.new,
    );
  }
}
