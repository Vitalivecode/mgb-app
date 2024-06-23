import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:system_info/system_info.dart';

class ImagepickerController extends GetxController {
  final RxList<File> images = RxList<File>([]);
  final RxList<File> fileImageArray = RxList<File>([]);
  final RxList<Widget> imagesListUI = RxList<Widget>([]);
  RxBool isLoading = false.obs;
  var ram;

  showDeviceLowSpecAlert() async {
    ram = SysInfo.getTotalPhysicalMemory();
    ram = ram ~/ 1024;
    ram = ram ~/ 1024;
    ram = ram ~/ 1024;
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

  Future alertDialogOfLowSpecUI(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Phone Low Specification'),
          content: const Text(
            'Your phone has the less system requirement at running this app. so upload the images 25 at a time',
          ),
          actions: [
            TextButton(
              onPressed: () {
                var count = 0;
                Navigator.popUntil(context, (route) {
                  if (count == 2) {
                    return true;
                  } else {
                    count++;
                    return false;
                  }
                });
              },
              child: const Text('No'),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // Navigator.pop(context);
                loadAssets(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<List<File>> loadAssets(context) async {
    try {
      if (fileImageArray.isNotEmpty && fileImageArray.length < 25) {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );
        final files = result!.files.toList();
        for (var i = 0; i < result.files.length; i++) {
          fileImageArray.add(File(files[i].path!));
        }
      }

      if (fileImageArray.isEmpty) {
        final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );
        final files = result!.files.toList();
        for (int i = 0; i < files.length; i++) {
          fileImageArray.add(File(files[i].path!));
        }
      }

      if (fileImageArray.length > 25) {
        fileImageArray.removeRange(25, fileImageArray.length);
        AppUtils.flushbarShow(
          Colors.red,
          'Uploading 25 Images is the limit for uploading at a time removing the extra images',
          context as BuildContext,
        );
      }
      images.value = fileImageArray;
      fileImageArray.value = fileImageArray;
      buildGridView(context);
      return fileImageArray;
    } on Exception catch (e) {
      print('cannot select the images $e');
      return [];
    }
  }

  buildGridView(context) {
    imagesListUI.value = [];
    print('inside the fileupload');
    if (imagesListUI.length <= 20) {
      for (var i = 0; i < images.length; i++) {
        imagesListUI.add(
          Padding(
            padding: const EdgeInsets.all(1),
            child: InkWell(
              onTap: () {
                showDialog<void>(
                  context: context as BuildContext,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
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
                          onPressed: () {
                            Get.back();
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
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
      imagesListUI.value = imagesListUI;
      // setState(() {
      //   imagesListUI = imagesListUI;
      // });
    }
  }

  @override
  onInit() {
    showDeviceLowSpecAlert();
    super.onInit();
  }
}
