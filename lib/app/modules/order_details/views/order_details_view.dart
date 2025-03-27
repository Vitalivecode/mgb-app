import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/order_album/widgets/address_card.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';
import 'package:mygallerybook/core/app_colors.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              }),
          title: Text(controller.albumId,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 20, color: AppColors.white)),
        ),
        backgroundColor: AppColors.white,
        body: FutureBuilder(
            future: Future.wait([
              controller.orderDetailsFuture,
              controller.profileDetailsFuture,
              controller.deliveryDetailsFuture,
            ].cast()), // listOfFutures.cast<Future<dynamic>>()
            builder: (context, snp) {
              if (snp.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    controller.orders == null
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                        : Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          controller.albumId,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          child: Text(
                                            "${controller.images.length} Uploaded",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 05),
                                          decoration: BoxDecoration(
                                              color: controller.oStatus == "1"
                                                  ? AppColors.color1
                                                  : controller.oStatus == "5"
                                                      ? AppColors.green
                                                      : AppColors.color3,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              controller.getStatus(
                                                      controller.oStatus) ??
                                                  "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                      color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          child: Text(
                                            "${100 - controller.images.length} remaining",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              controller.profile == null ||
                                      controller.address == null
                                  ? const CircularProgressIndicator()
                                  : CustomItem(
                                      selectItem: controller.selectItem,
                                      index: 1,
                                      isSelected: true,
                                      profileDetail:
                                          "${controller.profile["cFName"]} ${controller.profile["cLName"]},\n${controller.phone},\n${controller.profile["cEmail"]}",
                                      address:
                                          "${controller.address["cDoorNo"]},\n${controller.address["cStreet"]},\n${controller.address["cLandMark"]},\n${controller.address["cCity"]},\n${controller.address["cPincode"]} ",
                                    )
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: controller.showWidgets(
                            height,
                            width,
                            context,
                            controller.getStatus(controller.oStatus),
                            controller.albumId),
                      ),
                    ),
                    controller.orders != null &&
                            controller.oStatus == "someStatus"
                        ? Expanded(child: controller.buildGridView())
                        : Container(),
                  ],
                );
              } else if (snp.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator(
                  minHeight: 7,
                );
              } else if (snp.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.5,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.signal_wifi_off,
                            size: 80,
                            color: AppColors.blue,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Failed To Load the Data Please connect to internet and try again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else
                return Container();
            }),
      ),
    );
  }
}
