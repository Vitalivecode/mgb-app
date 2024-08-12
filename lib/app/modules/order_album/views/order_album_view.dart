import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/order_album/controllers/order_album_controller.dart';
import 'package:mygallerybook/app/modules/order_album/widgets/address_card.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:mygallerybook/core/reusable_widgets/my_textformfield.dart';

class OrderAlbumView extends GetView<OrderAlbumController> {
  const OrderAlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Obx(
        () => controller.profile.value.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  SafeArea(
                    child: Container(
                        child: !controller.isLoading.value
                            ? Center(
                                child: Wrap(
                                  children: <Widget>[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          'Total Selected Images ${controller.images.length}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Select Delivery Address',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                    color: AppColors.black),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Obx(
                                          () => Column(
                                              children: controller.details
                                                  .asMap()
                                                  .entries
                                                  .map(
                                            (entry) {
                                              int index = entry.key;
                                              var detail = entry.value;
                                              return CustomItem(
                                                selectItem:
                                                    controller.selectItem,
                                                index: index,
                                                profileDetail: controller
                                                        .profileDetail.value ??
                                                    '',
                                                address:
                                                    "${detail["cDoorNo"]},\n${detail["cStreet"]},\n${detail["cLandMark"]},\n${detail["cCity"]},\n${detail["cPincode"]} ",
                                                isSelected: controller
                                                            .selectedItem
                                                            .value ==
                                                        index
                                                    ? true
                                                    : false,
                                              );
                                            },
                                          ).toList()),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: MyButton(
                                            btntext: 'Add New Address',
                                            border: false,
                                            color: AppColors.blue,
                                            textcolor: AppColors.blue,
                                            onPress: () {
                                              Get.toNamed(
                                                      Routes.CREATE_ADDRESS)!
                                                  .then((value) {
                                                controller.getAddress();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: textTheme.titleLarge!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (controller.count.value >
                                                    1) {
                                                  controller.count.value -= 1;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                size: 32,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              controller.count.value.toString(),
                                              style: textTheme.titleLarge!
                                                  .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                if (controller.count.value <
                                                    5) {
                                                  controller.count.value += 1;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.add_circle,
                                                size: 32,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: MyTextFormField(
                                        icon: const Icon(
                                          Icons.description,
                                          size: 30,
                                        ),
                                        hintText: 'Description',
                                        maxLines: 4,
                                        controller: controller.notes,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue:
                                          controller.isAlbumPrint.value == true,
                                      onChanged: (value) async {
                                        final bool? res = await AppUtils
                                            .showConfirmationAlbumAlert(context,
                                                controller.images.length);
                                        controller.isAlbumPrint.value = res!;
                                      },
                                      title: const Text(
                                          "Photos are no more. Print album"),
                                      activeColor: colorScheme.primary,
                                    ),
                                    RadioListTile(
                                      value: true,
                                      groupValue:
                                          controller.isAlbumPrint.value ==
                                              false,
                                      onChanged: (value) {
                                        controller.isAlbumPrint.value = !value!;
                                      },
                                      title: const Text(
                                        "There are still photos I need to send",
                                      ),
                                      activeColor: colorScheme.primary,
                                    ),
                                    Center(
                                      child: MyButton(
                                        onPress: () {
                                          controller.imagegs();
                                        },
                                        btntext: 'Place Order',
                                        color: AppColors.blue,
                                        textcolor: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(height: height * .1),
                                    Center(
                                      child: MyButton(
                                        onPress: () {
                                          var count = 0;
                                          Navigator.popUntil(context,
                                              (orroute) {
                                            if (count == 2) {
                                              return true;
                                            } else {
                                              count++;
                                              return false;
                                            }
                                          });
                                        },
                                        btntext: 'Cancel Order',
                                        border: false,
                                        color: Colors.transparent,
                                        textcolor:
                                            AppColors.color1.withOpacity(.5),
                                      ),
                                    ),
                                    SizedBox(height: height * .12),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  const LinearProgressIndicator(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                2),
                                    child: Text(
                                      "Images are uploading please wait...",
                                      style: textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                  ),
                ],
              ),
      ),
    );
  }
}

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(
    super.method,
    super.url, {
    required this.onProgress,
  });

  final void Function(int bytes, int totalBytes) onProgress;

  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
