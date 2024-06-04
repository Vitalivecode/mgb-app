import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/otp_verification/controllers/otp_verification_controller.dart';
import 'package:mygallerybook/core/app_assets.dart';
import 'package:mygallerybook/core/app_colors.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
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
                    onPressed: () {},
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
                Text('My Gallery Book',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 26, color: AppColors.white)),
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
                        "OTP Sent to ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 16, color: AppColors.black),
                      ),
                      Text(
                        controller.cPhone ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: AppColors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OtpTextField(
                    numberOfFields: 4,
                    borderColor: Colors.grey,
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      controller.otp = verificationCode;
                    }, // end onSubmit
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    onPress: () {
                      if (controller.otp == "") {
                        // flushBarshow("Please Enter OTP", context, red);
                      } else {
                        controller.verify();
                      }
                    },
                    btntext: "Verify OTP",
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
                        onTap: controller.resendotp,
                        child: Text(
                          "Resend",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  color: AppColors.red,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
