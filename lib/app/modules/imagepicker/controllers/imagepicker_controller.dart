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

  List<File> images = [];
  List<File> fileImageArray = [];
  List<Widget> imagesListUI = [];
  var isLoading = false;
  late int ram;

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
  alertDialogOfLowSpecUI(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Phone Low Specification"),
            content: const Text(
                "Your phone has the less system requirement at running this app. so upload the images 25 at a time"),
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
                  child: const Text('No')),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    loadAssets(context);
                  },
                  child: const Text('Yes'))
            ],
          );
        });
  }

  loadAssets(context) async {
    try {
      if (fileImageArray.length > 0 && fileImageArray.length < 25) {
        var result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );
        // var files = result.paths.map((path) => File(path));
        var files = result!.files.toList();
        for (var i = 0; i < result.files.length; i++) {
          fileImageArray.add(File(files[i].path!));
        }
      }

      if (fileImageArray.length == 0) {
        var result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.image,
        );
        var files = result!.files.toList();
        for (var i = 0; i < files.length; i++) {
          fileImageArray.add(File(files[i].path!));
        }
      }

      if (fileImageArray.length > 25) {
        fileImageArray.removeRange(25, fileImageArray.length);
        AppUtils.flushBarshow(
            "Uploading 25 Images is the limit for uploading at a time removing the extra images",
            context,
            Colors.red);
      }

      if (fileImageArray != null) {
          images = fileImageArray;
          fileImageArray = fileImageArray;
          buildGridView(context);

        return fileImageArray;
      }
    } on Exception catch (e) {
      print("cannot select the images $e");
    }
  }
  buildGridView(context) {
    imagesListUI = [];
    print("inside the fileupload");
    if (imagesListUI.length <= 20) {
      for (var i = 0; i < images.length; i++) {
        imagesListUI.add(Padding(
            padding: const EdgeInsets.all(1.0),
            child: InkWell(
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${basename(images[i].path)}'),
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
                            Navigator.of(context).pop();
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.image, color: AppColors.white),
                    title: Text(
                      "${basename(images[i].path)}",
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            )));
      }
      imagesListUI = imagesListUI;
      // setState(() {
      //   imagesListUI = imagesListUI;
      // });
    }
  }
}
