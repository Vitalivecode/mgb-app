import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/subscription/widgets/subscription_card.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/reusable_widgets/shimmer_image.dart';

class SubscriptionController extends GetxController {
  Future? packs;

  final templateCards = <Widget>[].obs;
  final subscriptionCards = <Widget>[].obs;
  final details = RxMap<String, dynamic>({});

  getpacks() async {
    try {
      final url = Uri.parse(AppUrls.productionHost + AppUrls.packs);
      final request = http.MultipartRequest('GET', url);
      final response = await request.send();
      final data = await response.stream.transform(utf8.decoder).join();

      final Map<String, dynamic> jsonResponse = jsonDecode(data);

      details.value = jsonResponse;

      getTemplateImages();
      subscriptionPackCards();
    } catch (e) {
      print("Error fetching packs: $e");
    }
  }

  subscriptionPackCards() {
    subscriptionCards.clear();
    List<dynamic> subscriptionData = details['SubscriptionData'] ?? [];

    for (int index = 0; index < subscriptionData.length; index++) {
      final data = subscriptionData[index];
      subscriptionCards.add(
        SizedBox(
          width: double.infinity,
          child: SubscriptionCards(
            month: data['sMonths'].toString(),
            title: data['sName'].toString(),
            offer: data['sOfferCost'].toString(),
            amount: (int.parse(data['sCost'].toString()) /
                    int.parse(data['sMonths'].toString()))
                .round()
                .toString(),
            albums: data['sAlbums'].toString(),
            color: index == 0
                ? AppColors.color1
                : index == 1
                    ? AppColors.color2
                    : AppColors.color3,
            onPress: () {
              print("Subscription pack called");
              Get.toNamed(
                Routes.PAYMENT,
                arguments: {
                  'data': subscriptionData,
                  'index': index,
                  'color': index == 0
                      ? AppColors.color1
                      : index == 1
                          ? AppColors.color2
                          : AppColors.color3,
                },
              );
            },
          ),
        ),
      );
    }
  }

  getTemplateImages() {
    templateCards.clear();
    List<dynamic> templateData = details['TemplateData'] ?? [];
    for (int i = 0; i < templateData.length; i++) {
      final data = templateData[i];
      templateCards.add(
        Builder(
          builder: (context) {
            return Card(
              elevation: 4,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: AppUrls.productionHost +
                      AppUrls.templateimages +
                      data['tImage'].toString(),
                  fit: BoxFit.fill,
                  height: 500,
                  width: 500,
                  placeholder: (context, url) => const ShimmerImage(
                    width: double.infinity,
                    height: 200, // Adjust according to your layout
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void onInit() {
    packs = getpacks();
    super.onInit();
  }
}
