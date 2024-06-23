import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/all_orders/controllers/all_orders_controller.dart';
import 'package:mygallerybook/app/modules/all_orders/widgets/order_card.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class AllOrdersView extends GetView<AllOrdersController> {
  const AllOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigator.of(context).pop(true);
                Get.back();
              },
            ),
            title: Text(
              'My Orders',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 20, color: AppColors.white),
            ),
          ),
          backgroundColor: AppColors.white,
          body: Obx(
            () => Column(
              children: <Widget>[
                Expanded(
                  child: controller.orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/empty.png'),
                              Text(
                                'No Albums Ordered Yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 18,
                                      color: AppColors.color1.withOpacity(.5),
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            // log("My orders is calling");
                            final status = controller.orders[index]['oStatus'];
                            return OrderCard(
                              album: controller.orders[index]['albumId']
                                  .toString(),
                              color: controller.orders[index]['oStatus'] == '1'
                                  ? AppColors.color1
                                  : controller.orders[index]['oStatus'] == '5'
                                      ? AppColors.green
                                      : AppColors.color3,
                              status: controller.getStatus(status.toString()),
                              timages:
                                  controller.orders[index]['NofoImages'] as int,
                              onPress: () {
                                Get.toNamed(
                                  Routes.ORDER_DETAILS,
                                  arguments: {
                                    'aid': controller.orders[index]['aId'],
                                    'pid': controller.orders[index]['pId'],
                                    'albumId': controller.orders[index]
                                        ['albumId'],
                                    // 'cid': controller.cid ?? '',
                                    'cid': MyGalleryBookRepository.getCId(),
                                    'feedback': controller.orders[index]
                                            ['feedback'] ??
                                        '',
                                  },
                                );
                              },
                              image1: controller.orders[index]['UploadImages']
                                      [0]
                                  .toString(),
                              image2: controller.orders[index]['UploadImages']
                                          .toString()
                                          .length >
                                      1
                                  ? controller.orders[index]['UploadImages'][1]
                                      .toString()
                                  : null,
                              image3: controller.orders[index]['UploadImages']
                                          .toString()
                                          .length >
                                      2
                                  ? controller.orders[index]['UploadImages'][2]
                                      .toString()
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
