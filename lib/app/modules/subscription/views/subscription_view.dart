import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/subscription/controllers/subscription_controller.dart';
import 'package:mygallerybook/core/app_colors.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Subscriptions'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: Get.back,
          ),
        ),
        body: Container(
          height: height,
          width: width,
          color: AppColors.white,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Obx(() => buildCarouselSlider()),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Select Subscription Pack',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Center(
                child: SizedBox(
                  width: width * .7,
                  child: Text(
                    'Select your Subscription Pack to get activated and order the books',
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
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: Column(
                        children: controller.subscriptionCards,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return const IgnorePointer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  CarouselSlider buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 0.5,
      ),
      items: controller.templateCards,
    );
  }
}
