import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/app/modules/payment/controllers/payment_controller.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({
    super.key,
    this.data,
    this.index,
    this.color,
  });

  final data;
  final int? index;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Obx(
        () => Container(
          height: height,
          width: width,
          color: controller.mycolor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${controller.selectedpack[controller.pack]["sName"]}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: width * .17,
                      color: AppColors.white,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Rs. ',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.white, fontSize: 36, height: 3),
                  ),
                  if (int.parse(
                        controller.selectedpack[controller.pack]['sOfferCost']
                            .toString(),
                      ) >
                      0)
                    Text(
                      "${controller.selectedpack[controller.pack]["sOfferCost"]}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .2,
                            height: 1.2,
                          ),
                    )
                  else
                    Text(
                      "${controller.selectedpack[controller.pack]["sCost"]}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .2,
                            height: 1.2,
                          ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${int.parse(controller.selectedpack[controller.pack]["sMonths"].toString()) > 1 ? controller.selectedpack[controller.pack]["sMonths"] + " Months" : controller.selectedpack[controller.pack]["sMonths"] + " Month"} validity",
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${int.parse(controller.selectedpack[controller.pack]["sAlbums"].toString()) > 1 ? controller.selectedpack[controller.pack]["sAlbums"] + " Photobooks" : controller.selectedpack[controller.pack]["sAlbums"] + " Photobook"}",
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '1 Photobook per Month',
                    style: TextStyle(color: AppColors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 50),
                  MyButton(
                    btntext: controller.btnText.value ?? '',
                    onPress: controller.pay.value
                        ? () {}
                        : () {
                            controller.totalAmount.value = int.parse(
                                      controller.selectedpack[controller.pack]
                                              ['sOfferCost']
                                          .toString(),
                                    ) >
                                    0
                                ? int.parse(
                                    controller.selectedpack[controller.pack]
                                            ['sOfferCost']
                                        .toString(),
                                  )
                                : int.parse(
                                    controller.selectedpack[controller.pack]
                                            ['sCost']
                                        .toString(),
                                  );
                            controller
                                .openCheckout(controller.totalAmount.value);
                          },
                    color: AppColors.white,
                    textcolor: controller.mycolor!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    btntext: 'Change Pack',
                    onPress: () {
                      Get.toNamed(Routes.SUBSCRIPTION);
                    },
                    color: controller.mycolor!,
                    textcolor: AppColors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
