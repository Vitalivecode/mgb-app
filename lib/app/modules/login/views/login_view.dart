import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/login/controllers/login_controller.dart';
import 'package:mygallerybook/core/app_assets.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/reusable_widgets/my_gallery_book_backGround.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyGalleryBookBackground(
              height: height * 0.4,
              width: width,
              color: AppColors.blue,
              image: AppAssets.appIcon,
              textColor: AppColors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1),
                  Form(
                    key: controller.formKey,
                    child: TextFormField(
                      maxLength: 10,
                      controller: controller.phoneNumber,
                      keyboardType: TextInputType.number,
                      validator: (value) => controller.validator(value),
                      style: textTheme.bodyLarge!.copyWith(
                        fontSize: width * .04,
                        inherit: true,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        errorStyle: textTheme.bodyLarge!.copyWith(
                          fontSize: width * .03,
                          fontWeight: FontWeight.w900,
                          color: AppColors.red,
                        ),
                        isDense: true,
                        prefixIcon: const Icon(Icons.sim_card),
                        filled: true,
                        fillColor: AppColors.blue.withOpacity(.15),
                        labelText: 'Phone Number',
                        labelStyle: textTheme.bodyLarge!.copyWith(
                          fontSize: width * .04,
                          inherit: true,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        hintText: 'Enter Phone Number',
                        hintStyle: textTheme.bodyLarge!.copyWith(
                          fontSize: width * .04,
                          inherit: true,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: width * .04),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(width * .04),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  MyButton(
                    onPress: () {
                      controller.check(context);
                    },
                    btntext: 'Get OTP',
                    color: AppColors.blue,
                    textcolor: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
