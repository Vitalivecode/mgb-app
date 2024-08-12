import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:system_info/system_info.dart';

class ImagepickerController extends GetxController {
  final RxList<File> images = RxList<File>([]);
  final RxList<Widget> imagesListUI = RxList<Widget>([]);
  RxBool isLoading = false.obs;
  var ram;

  @override
  void onInit() {
    showDeviceLowSpecAlert();
    super.onInit();
  }

  Future<void> showDeviceLowSpecAlert() async {
    ram = SysInfo.getTotalPhysicalMemory();
    ram = ram ~/ 1024 ~/ 1024 ~/ 1024;
    await _deleteCacheDir();
    await _deleteAppDir();
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();
    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  // Future<void> alertDialogOfLowSpecUI(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Phone Low Specification'),
  //         content: const Text(
  //           'Your phone has the less system requirement at running this app. So upload the images 25 at a time',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               var count = 0;
  //               Navigator.popUntil(context, (route) {
  //                 if (count == 2) {
  //                   return true;
  //                 } else {
  //                   count++;
  //                   return false;
  //                 }
  //               });
  //             },
  //             child: const Text('No'),
  //           ),
  //           const SizedBox(width: 10),
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //               loadAssets(context);
  //             },
  //             child: const Text('Yes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> loadAssets(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        final files = result.files.map((file) => File(file.path!)).toList();
        if (files.isNotEmpty) {
          images.addAll(files);
          if (images.length > 25) {
            images.removeRange(25, images.length);
            AppUtils.flushbarShow(
              Colors.red,
              'Uploading 25 images is the limit for uploading at a time. Removing the extra images.',
              context,
            );
          }
          buildGridView();
        }
      }
    } catch (e) {
      print('Cannot select the images: $e');
    }
  }

  void showConfirmationAlert(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload'),
          content: const Text(
            'Are you sure do you want to continue to upload the images?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.toNamed<void>(Routes.ORDER_ALBUM, arguments: images);
              },
              child: const Text('Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  )),
            ),
            TextButton(
              onPressed: Get.back<void>,
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void buildGridView() {
    imagesListUI.clear();
    for (var i = 0; i < images.length; i++) {
      imagesListUI.add(
        Padding(
          padding: const EdgeInsets.all(1),
          child: InkWell(
            onTap: () {
              Get.dialog<void>(
                AlertDialog(
                  title: Text(basename(images[i].path)),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Image.file(
                          images[i],
                          height: 400,
                          width: 400,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              );
            },
            child: Card(
              color: AppColors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.image, color: AppColors.white),
                  title: Text(
                    basename(images[i].path),
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
