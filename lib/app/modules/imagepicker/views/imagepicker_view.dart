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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child:  Scaffold(
        appBar: AppBar(
          title: const Text("Order Album"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Upload Images 25 out of 100 at a time"),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          MyButton(
                            onPress: () {
                              if (controller.ram < 4) {
                                controller.alertDialogOfLowSpecUI(context);
                              } else {
                                controller.loadAssets(context);
                              }
                            },
                            btntext: controller.fileImageArray.length > 0
                                ? "Select More"
                                : "Select images",
                            color: AppColors.blue,
                            textcolor: AppColors.white,
                          ),
                          const SizedBox(height: 20),
                          if(controller.fileImageArray.length > 0)  MyButton(
                            onPress: controller.fileImageArray.length >= 1
                                ? () {
                              // showConfirmationAlert(context);
                              AppUtils.showConfirmationAlert(context);
                            }
                                : () {
                              AppUtils.flushBarshow(
                                  "Please Select Min. 1 Image, Max. of 25 Images alloweda at a time",
                                  context,
                                  AppColors.red);
                            },
                            btntext: "Order Album",
                            color: AppColors.blue,
                            border: false,
                            textcolor: AppColors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.fileImageArray.length > 0
                      ? Column(children: [
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
                                    text: "${controller.fileImageArray.length} ",
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
                    controller.isLoading
                        ? const CircularProgressIndicator()
                        : Wrap(children: controller.imagesListUI)
                  ])
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
