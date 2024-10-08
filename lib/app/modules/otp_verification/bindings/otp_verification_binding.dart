import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/otp_verification/controllers/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
      OtpVerificationController.new,
    );
  }
}
