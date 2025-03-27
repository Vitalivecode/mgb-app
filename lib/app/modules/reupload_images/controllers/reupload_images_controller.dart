import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ReuploadImagesController extends GetxController {
  var timages;
  var album;
  var aid;
  var pid;
  var cid;
  List<File> images = [];
  final RxList<File> fileImageArray = RxList<File>([]);
  List<Widget> imagesListUI = [];
  final isLoading = false.obs;
  double percentage = 1.0;
  var details = [];
  String? uploadText = 'Uploading Images...';
  final isAlbumPrint = false.obs;
  bool show = true;

  @override
  void onInit() {
    final args = Get.arguments;
    print('$args these are the arguments that we are getting');
    aid = args['aid'];
    timages = args['imagesLength'];
    print("$timages + this is the imagesLength");
    album = args['albumId'];
    pid = args['pid'];
    cid = args['cid'];
    super.onInit();
  }

  buildGridView(BuildContext context, List<File> images) {
    imagesListUI.clear(); // Clear any previous UI elements to avoid duplicates
    for (var i = 0; i < images.length; i++) {
      imagesListUI.add(
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: InkWell(
            onTap: () {
              showDialog<void>(
                context: context,
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

  Future<void> loadAssets(BuildContext context) async {
    try {
      var result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );
      if (result != null) {
        var files = result.files.map((file) => File(file.path!)).toList();

        if (files.length > 25) {
          AppUtils.flushbarShow(
            Colors.red,
            "Uploading 25 Images is the Limit removing Extra Images",
            context,
          );
          files = files.sublist(0, 25);
        }

        if ((timages + fileImageArray.length + files.length) > 100) {
          int extraImages =
              (timages + fileImageArray.length + files.length) - 100;
          files = files.sublist(0, files.length - extraImages);
          AppUtils.flushbarShow(
            Colors.red,
            "Total 100 Images is the Limit, removing Extra Images",
            context,
          );
        }

        fileImageArray.addAll(files); // Add new files to the list
        images = fileImageArray.toList();
        buildGridView(context, images);
      }
    } catch (e) {
      print("Cannot select the images: $e");
    }
  }

  // void showConfirmationAlert(BuildContext context1) {
  //   showDialog(
  //     context: context1,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Confirm Upload"),
  //         content: const Text(
  //             "Are you sure you want to continue to upload the images?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //               uploadImages();
  //             },
  //             child: const Text("Confirm"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  Future<void> uploadImages() async {
    isLoading.value = true;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://www.mygallerybook.com/order'),
      );

      request.fields.addAll({
        "albumId": album,
        "cId": cid,
        "aId": aid,
        "pId": pid,
      });
      for (var file in images) {
        String mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        String fileName = path.basename(file.path);
        request.files.add(
          await http.MultipartFile.fromPath(
            'image[]',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        if (response.statusCode == 200) {
          log("Inside the success response");
          if (value.toLowerCase().contains("next month")) {
            AppUtils.flushbarShow(AppColors.color3, value, Get.context!);
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2500), () {
              Get.offAllNamed(Routes.HOME);
            });
          } else if (value.toLowerCase().contains("closed")) {
            AppUtils.flushbarShow(AppColors.color3, value, Get.context!);
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2500), () {
              Get.offAllNamed(Routes.HOME);
            });
          } else if (value.contains(RegExp(r'Success', caseSensitive: false))) {
            AppUtils.flushbarShow(
              AppColors.green,
              "$value Images Uploaded",
              Get.context!,
            );
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          } else if (RegExp(
                  r'\b(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25)\b')
              .hasMatch(value)) {
            AppUtils.flushbarShow(
              AppColors.green,
              "$value Images Uploaded",
              Get.context!,
            );
            isLoading.value = false;
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          } else {
            AppUtils.flushbarShow(
              AppColors.red,
              "Unexpected Response: $value",
              Get.context!,
            );
            uploadText = value;
            Future.delayed(const Duration(milliseconds: 2000), () async {
              await _deleteAppDir();
              Get.toNamed(Routes.HOME);
            });
          }
        } else {
          log("Inside the failure response");
          AppUtils.flushbarShow(
            AppColors.red,
            "Error: ${response.reasonPhrase}",
            Get.context!,
          );
        }
      });
    } catch (e) {
      print(
        "Error during image upload: $e",
      );
      AppUtils.flushbarShow(
        AppColors.red,
        "Image upload failed",
        Get.context!,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
