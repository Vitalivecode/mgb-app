import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/order_album/controllers/order_album_controller.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/reusable_widgets/my_textformfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OrderAlbumView extends GetView<OrderAlbumController> {
  const OrderAlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: controller.profile! == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SafeArea(
                  child: Container(
                    child: !controller.isLoading
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
                                            ?.copyWith(color: AppColors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: controller.getAddressListUI(),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: MyButton(
                                        btntext: 'Add New Address',
                                        border: false,
                                        color: AppColors.blue,
                                        textcolor: AppColors.blue,
                                        onPress: () {
                                          Get.toNamed(Routes.CREATE_ADDRESS)!
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
                                        const Text('Quantity'),
                                        Text(
                                          (controller.count ?? 1).toString(),
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
                                Center(
                                  child: MyButton(
                                    onPress: () {
                                      // imagegs(context);
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
                                      Navigator.popUntil(context, (route) {
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
                                    textcolor: AppColors.color1.withOpacity(.5),
                                  ),
                                ),
                                SizedBox(height: height * .12),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.95,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: 200,
                                  lineWidth: 30,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  linearGradient: LinearGradient(
                                    colors: [
                                      AppColors.blue.withOpacity(.6),
                                      AppColors.darkBlue,
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.bottomRight,
                                    tileMode: TileMode.mirror,
                                  ),
                                  arcType: ArcType.FULL,
                                  arcBackgroundColor:
                                      AppColors.color1.withOpacity(.1),
                                  backgroundWidth: 0,
                                  curve: Curves.slowMiddle,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  percent: controller.percentage,
                                  header: Text(
                                    controller.uploadtext ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontSize: 23),
                                  ),
                                  footer: Text(
                                    '${(controller.sentbytes * 0.00000095367432).toStringAsFixed(2)} MB / ${(controller.totalbytes * 0.00000095367432).toStringAsFixed(2)} MB',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontSize: 18),
                                  ),
                                  center: controller.percentage == 1.0
                                      ? Icon(
                                          Icons.cloud_done,
                                          color: AppColors.darkBlue
                                              .withOpacity(.6),
                                          size: 80,
                                        )
                                      : Text(
                                          '${(controller.percentage * 100).toStringAsFixed(1)}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(fontSize: 23),
                                        ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
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
