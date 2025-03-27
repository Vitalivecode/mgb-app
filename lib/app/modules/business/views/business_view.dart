import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/business/widgets/home_card.dart';
import 'package:mygallerybook/app/modules/business/widgets/packs_not_found.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class BusinessView extends GetView<BusinessController> {
  const BusinessView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => controller.packs.value.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Wrap(
                      children: [
                        SizedBox(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height * .02,
                              ),
                              Text(
                                'My Gallerybook 2.0',
                                style: textTheme.bodyLarge!
                                    .copyWith(fontSize: width * .07),
                              ),
                              Text(
                                'Things End but Memories Last Forever',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: width * .04),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (controller.subscriptionEndedDate.value! <
                                      0) {
                                    Get.toNamed(Routes.SUBSCRIPTION);
                                  }
                                },
                                child: Obx(
                                  () => HomeCard(
                                    description: (() {
                                      if (controller.date.value != null &&
                                              controller
                                                  .date.value!.isNotEmpty ||
                                          controller.day.value != null &&
                                              controller
                                                  .day.value!.isNotEmpty) {
                                        if (controller.subscriptionEndedDate
                                                    .value! >=
                                                0 ||
                                            controller.packs.value[controller
                                                        .packs.value.length -
                                                    1]["sRemainAlbums"] ==
                                                "0") {
                                          if (controller.day.value != null) {
                                            String days = int.parse(
                                                        '${controller.day}') >
                                                    1
                                                ? "${controller.day.value.toString()} days"
                                                : "${controller.day.value.toString()} day";

                                            String photobooks = controller
                                                        .packs.value[controller
                                                            .packs
                                                            .value
                                                            .length -
                                                        1]["sRemainAlbums"] ==
                                                    "1"
                                                ? controller.packs
                                                            .value[controller.packs.value.length - 1]
                                                        ["sRemainAlbums"] +
                                                    " Photobook"
                                                : controller.packs
                                                            .value[controller.packs.value.length - 1]
                                                        ["sRemainAlbums"] +
                                                    " Photobooks";
                                            return "$days and $photobooks left";
                                          } else {
                                            String months = int.parse(
                                                        '${controller.date}') >
                                                    1
                                                ? '${controller.date} Months'
                                                : int.parse('${controller.date}') >=
                                                        0
                                                    ? '${controller.date} Month'
                                                    : "0 Month";

                                            String photobooks = controller
                                                        .packs.value[controller
                                                            .packs
                                                            .value
                                                            .length -
                                                        1]["sRemainAlbums"] ==
                                                    "1"
                                                ? controller.packs
                                                            .value[controller.packs.value.length - 1]
                                                        ["sRemainAlbums"] +
                                                    " Photobook"
                                                : controller.packs
                                                            .value[controller.packs.value.length - 1]
                                                        ["sRemainAlbums"] +
                                                    " Photobooks";
                                            return "$months and $photobooks left";
                                          }
                                        } else {
                                          if (controller.subscriptionEndedDate
                                                  .value! <=
                                              0) {
                                            return "Subscription ended tap to renewal";
                                          }
                                          return "Photobooks Completed tap to renewal";
                                        }
                                      } else {
                                        return "";
                                      }
                                    })(),
                                    color: AppColors.blue,
                                    expireDate: '${controller.expireDate}',
                                    onPress: () {
                                      // Get.toNamed(Routes.TEMPLATES);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'My Recent Orders',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: width * .055,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.ALL_ORDERS);
                                      },
                                      child: Text(
                                        'All Orders',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: width * .04,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (controller.orders.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/empty.png',
                                        width: width * .4,
                                      ),
                                      Text(
                                        'No Photobooks Ordered Yet',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                              fontSize: width * .04,
                                              color:
                                                  AppColors.color1.withOpacity(
                                                .5,
                                              ),
                                            ),
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      Obx(
                                        () => MyButton(
                                          btntext: 'Start Creating',
                                          color: AppColors.blue,
                                          textcolor: AppColors.white,
                                          onPress: controller.packs.value[
                                                      controller.packs.value
                                                              .length -
                                                          1]['sRemainAlbums'] ==
                                                  0
                                              ? () {
                                                  Get.toNamed(
                                                    Routes.SUBSCRIPTION,
                                                  );
                                                }
                                              : () {
                                                  Feedback.forTap(
                                                    context,
                                                  );
                                                  HapticFeedback.lightImpact();
                                                  Get.toNamed(
                                                      Routes.IMAGEPICKER);
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: controller.orders[0] == 'Error'
                                    ? [
                                        PacksNotFound(
                                            height: height,
                                            color: AppColors.red)
                                      ]
                                    : controller.orderAlbums(),
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
