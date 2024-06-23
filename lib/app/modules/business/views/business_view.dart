import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/business/controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/business/widgets/home_card.dart';
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
        child: controller.packs.value == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Obx(
                () => ListView(
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
                              HomeCard(
                                description:
                                    "${int.parse('${controller.date}') > 1 ? '${controller.date}' " Months" : '${controller.date}' " Month"} and ${controller.packs.value[controller.packs.value.length - 1]["sRemainAlbums"] == "1" ? controller.packs.value[controller.packs.value.length - 1]["sRemainAlbums"] + " Photobook" : controller.packs.value[controller.packs.value.length - 1]["sRemainAlbums"] + " Photobooks"} left",
                                color: AppColors.blue,
                                expireDate: '${controller.expireDate}',
                                onPress: () {
                                  Get.toNamed(Routes.TEMPLATES);
                                },
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
                                      MyButton(
                                        btntext: 'Start Creating',
                                        color: AppColors.blue,
                                        textcolor: AppColors.white,
                                        onPress: controller.packs.value[
                                                    controller.packs.value
                                                            .length -
                                                        1]['sRemainAlbums'] ==
                                                '0'
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
                                                Get.toNamed(Routes.IMAGEPICKER);
                                                // print(
                                                //     controller.packs.toString() +
                                                //         "I am printing");
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Column(
                                children: controller.orders[0] == 'Error'
                                    ? [
                                        packsNotFound(
                                          height,
                                        ),
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

  Container packsNotFound(height) => Container(
        alignment: Alignment.center,
        height: height * 0.5,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 80,
              color: AppColors.red,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Failed To Load the Photobooks Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}
