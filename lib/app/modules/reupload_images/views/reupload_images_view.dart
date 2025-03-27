import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';

import '../controllers/reupload_images_controller.dart';

class ReuploadImagesView extends GetView<ReuploadImagesController> {
  const ReuploadImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order Album"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              }),
        ),
        body: SafeArea(
            child: ListView(
          children: <Widget>[
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          100 - controller.timages >= 25
                              ? Text(
                                  "You can Upload 25 Out of ${100 - controller.timages} at a time",
                                  style: textTheme.titleLarge,
                                )
                              : Text(
                                  "You can Upload ${controller.timages} at a time",
                                  style: textTheme.titleLarge,
                                ),
                          const SizedBox(height: 16),
                          controller.fileImageArray.length >= 25
                              ? Container()
                              : MyButton(
                                  onPress: () async {
                                    controller.loadAssets(context);
                                  },
                                  btntext: (controller.timages +
                                              controller
                                                  .fileImageArray.length) >
                                          0
                                      ? "Select More"
                                      : "Select images",
                                  color: AppColors.blue,
                                  textcolor: AppColors.white,
                                ),
                          const SizedBox(height: 20),
                          controller.fileImageArray.isNotEmpty
                              ? MyButton(
                                  onPress: () {
                                    return Get.dialog(AlertDialog(
                                      title: const Text(
                                        'Confirm Upload',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: const Text(
                                        'Are you sure do you want to continue to upload the images?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.uploadImages();
                                          },
                                          child: const Text(
                                            'Confirm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back(result: false);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ));
                                  },
                                  btntext: "Order Album",
                                  color: AppColors.blue,
                                  border: false,
                                  textcolor: AppColors.blue,
                                )
                              : const LimitedBox(),
                        ],
                      ),
                    ),
                  ),
                  controller.fileImageArray.isNotEmpty
                      ? Column(children: [
                          RadioListTile(
                            value: true,
                            groupValue: controller.isAlbumPrint.value == true,
                            onChanged: (value) async {
                              final bool? res =
                                  await AppUtils.showConfirmationAlbumAlert(
                                      context, controller.images.length);
                              controller.isAlbumPrint.value = res!;
                            },
                            title:
                                const Text("Photos are no more. Print album"),
                            activeColor: colorScheme.primary,
                          ),
                          RadioListTile(
                            value: true,
                            groupValue: controller.isAlbumPrint.value == false,
                            onChanged: (value) {
                              controller.isAlbumPrint.value = !value!;
                            },
                            title: const Text(
                              "There are still photos I need to send",
                            ),
                            activeColor: colorScheme.primary,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 25.0, color: Colors.black),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: " Selected ",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.blue)),
                                      TextSpan(
                                          text:
                                              "${controller.fileImageArray.length} ",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: "Images",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 25.0))
                                    ]),
                              ),
                            ),
                          ),
                          Wrap(children: controller.imagesListUI)
                        ])
                      : Container(),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
