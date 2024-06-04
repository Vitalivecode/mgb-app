import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/services.dart';

import '../controllers/business_controller.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
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
        child: controller.packs==null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          children: [
            FutureBuilder(
              future: controller.getMetaData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Wrap(
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: height*1,
                          child: const Column(
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
                                "Failed To Load the Data Please connect to internet and try again",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Wrap(
                      children: [
                        SizedBox(
                          width: width,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * .02,
                              ),
                              Text(
                                "My Gallerybook 2.0",
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
                                "${int.parse('${controller.date}') > 1 ? '${controller.date}' + " Months" : '${controller.date}' + " Month"} and ${controller.packs[controller.packs.length - 1]["sRemainAlbums"] == "1" ? controller.packs[controller.packs.length - 1]["sRemainAlbums"] + " Photobook" : controller.packs[controller.packs.length - 1]["sRemainAlbums"] + " Photobooks"} left",
                                color: AppColors.blue,
                                expireDate: "${controller.expireDate}",
                                onPress: () {
                                  // Navigator.of(context)
                                  //     .push(templates());
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "My Recent Orders",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                          fontSize: width * .055,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Navigator.of(context)
                                        //     .push(allOrders());
                                      },
                                      child: Text(
                                        "All Orders",
                                        textScaleFactor: 01,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                            fontSize: width * .04),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: controller.list,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return packsNotFound(height);
                              } else if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return const LinearProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Column(
                                  children: [
                                    controller.orders.isEmpty
                                        ? Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            top: 25.0),
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/empty.png",
                                              width: width * .4,
                                            ),
                                            Text(
                                              "No Photobooks Ordered Yet",
                                              style: Theme.of(
                                                  context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                  fontSize:
                                                  width *
                                                      .04,
                                                  color: AppColors
                                                      .color1
                                                      .withOpacity(
                                                      .5)),
                                            ),
                                            SizedBox(
                                                height:
                                                height * .02),
                                            MyButton(
                                              btntext:
                                              "Start Creating",
                                              color: AppColors.blue,
                                              textcolor:
                                              AppColors.white,
                                              onPress: controller
                                                  .packs[controller
                                                  .packs
                                                  .length -
                                                  1]["sRemainAlbums"] ==
                                                  "0"
                                                  ? () {
                                                // Navigator.of(
                                                //     context)
                                                //     .push(
                                                //     subscriptionpacks());
                                              }
                                                  : () {
                                                Feedback.forTap(
                                                    context);
                                                HapticFeedback
                                                    .lightImpact();
                                                // Navigator.of(
                                                //     context)
                                                //     .push(
                                                //     pickimages());
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                        : Column(
                                        children:
                                        controller.orders[0] ==
                                            "Error"
                                            ? [
                                          packsNotFound(
                                            height,
                                          )
                                        ]
                                            : controller
                                            .orderAlbums()),
                                  ],
                                );
                              } else
                                return const IgnorePointer();
                            }),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  packsNotFound(height) => Container(
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
              color: Colors.red, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class HomeCard extends StatelessWidget {
  final Color color;
  final String description;
  final String expireDate;
  final Function onPress;

  const HomeCard({
    super.key,
    required this.color,
    required this.description,
    required this.expireDate,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.9,
      height: height * 0.16,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.darkBlue, AppColors.blue2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(width * 0.4)),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      "My Subscription Pack",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.white,
                        fontSize: width * 0.6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * .027),
                Center(
                  child: Text(
                    description,
                    textScaleFactor: 01,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white, fontSize: width * .04),
                  ),
                ),
                SizedBox(height: width * .01),
                Text(
                  "Expire Date : $expireDate",
                  textScaleFactor: 01,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.white, fontSize: width * .04),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
