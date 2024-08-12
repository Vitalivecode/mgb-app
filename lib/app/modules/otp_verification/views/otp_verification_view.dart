import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/otp_verification/controllers/otp_verification_controller.dart';
import 'package:mygallerybook/core/app_assets.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            height: height * .45,
            width: width,
            color: AppColors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-width * .4, 0),
                  child: IconButton(
                    onPressed: Get.back,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Image.asset(
                  AppAssets.appIcon,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'My Gallery Book',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 26, color: AppColors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'OTP Sent to ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: AppColors.black),
                      ),
                      Text(
                        MyGalleryBookRepository.getCPhone() ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    controller: controller.pInputController,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryFixedDim.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onCompleted: (String verificationCode) {
                      controller.otp.value = verificationCode;
                    },
                  ),
                  // OtpTextField(
                  //   borderColor: Colors.grey,
                  //   showFieldAsBox: true,
                  //   onCodeChanged: (String code) {},
                  //   onSubmit: (String verificationCode) {
                  //     controller.otp = verificationCode;
                  //   }, // end onSubmit
                  // ),
                  const SizedBox(height: 30),
                  MyButton(
                    onPress: () {
                      if (controller.otp.value!.isEmpty) {
                        AppUtils.flushbarShow(
                          AppColors.red,
                          'Please Enter OTP',
                          context,
                        );
                      } else {
                        controller.verify();
                      }
                    },
                    btntext: 'Verify OTP',
                    color: AppColors.blue,
                    textcolor: AppColors.white,
                  ),
                  SizedBox(height: height * .1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Didn't Receive OTP, ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: AppColors.black),
                      ),
                      GestureDetector(
                        onTap: () async => await controller.resendOtp(),
                        child: Text(
                          'Resend',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
