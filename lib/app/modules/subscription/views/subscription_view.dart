import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mygallerybook/core/app_colors.dart';

import 'package:mygallerybook/app/modules/subscription/controllers/subscription_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Subscriptions'),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Container(
          height: height,
          width: width,
          color: AppColors.white,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: buildCarouselSlider(),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Select Subscription Pack",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Center(
                child: SizedBox(
                  width: width * .7,
                  child: Text(
                    "Select your Subscription Pack to get activated and order the books",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: controller.packs,
                  // ignore: missing_return
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      print("inside the done state");
                      return Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.05, right: width * 0.05),
                        child: Column(
                          children: controller.subscriptionCards,
                        ),
                      );
                    } else if (snapshot.hasError) {
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
                    }
                    else return const IgnorePointer();
                  })
            ],
          ),
        ),
      ),
    );
  }

  CarouselSlider buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        height: 200.0,
        autoPlay: true,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        aspectRatio: 0.5,
      ),
      items: controller.templateCards,
    );
  }
}
