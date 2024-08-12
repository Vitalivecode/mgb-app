import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/imagepicker/controllers/imagepicker_controller.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';

class ImagepickerView extends GetView<ImagepickerController> {
  const ImagepickerView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Album'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Upload Images 25 out of 100 at a time',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            controller.images.length < 25
                                ? MyButton(
                                    onPress: () {
                                      controller.loadAssets(context);
                                    },
                                    btntext: controller.images.isNotEmpty
                                        ? 'Select More'
                                        : 'Select images',
                                    color: AppColors.blue,
                                    textcolor: AppColors.white,
                                  )
                                : const LimitedBox(),
                            const SizedBox(height: 20),
                            if (controller.images.isNotEmpty)
                              MyButton(
                                onPress: () {
                                  if (controller.images.isNotEmpty) {
                                    controller.showConfirmationAlert(context);
                                  } else {
                                    AppUtils.flushbarShow(
                                      AppColors.red,
                                      'Please select at least 1 image. Max. of 25 images allowed at a time.',
                                      context,
                                    );
                                  }
                                },
                                btntext: 'Order Album',
                                color: AppColors.blue,
                                border: false,
                                textcolor: AppColors.blue,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.images.isNotEmpty)
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: ' Selected ',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${controller.images.length} ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Images',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Wrap(children: controller.imagesListUI),
                        ],
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
