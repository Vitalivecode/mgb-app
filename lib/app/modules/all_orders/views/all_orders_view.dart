import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/all_orders/controllers/all_orders_controller.dart';
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/modules/home/widgets/order_card.dart';
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
                            final order = controller.orders[index];
                            if (order.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            final status = order["oStatus"] ?? '1';
                            final uploadImages = order["UploadImages"] ?? [];
                            return OrderCard(
                              album: order["albumId"].toString(),
                              color: order["oStatus"] == '1'
                                  ? AppColors.color1
                                  : order["oStatus"] == '5'
                                      ? AppColors.green
                                      : AppColors.color3,
                              status: controller.getStatus(status.toString()),
                              timages: order["NofoImages"] ?? 0,
                              onPress: () {
                                Get.toNamed(
                                  Routes.ORDER_DETAILS,
                                  arguments: {
                                    'aid': order["aId"],
                                    'pid': order["pId"],
                                    'albumId': order["albumId"],
                                    'cid': MyGalleryBookRepository.getCId(),
                                    'feedback': order["feedback"] ?? '',
                                    "photos": order["UploadImages"],
                                  },
                                );
                              },
                              image1: uploadImages.isNotEmpty
                                  ? uploadImages[0].toString()
                                  : "",
                              image2: uploadImages.length > 1
                                  ? uploadImages[1].toString()
                                  : null,
                              image3: uploadImages.length > 2
                                  ? uploadImages[2].toString()
                                  : null,
                              image4: uploadImages.length > 3
                                  ? uploadImages[3].toString()
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
