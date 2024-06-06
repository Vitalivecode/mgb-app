import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/subscription/widgets/subscription_card.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  Future? packs;
  List<Widget> templateCards = [];
  var isLoaded = false;
  var details;
  List<Widget> subscriptionCards = [];

  getpacks() async {
    var url = Uri.parse(AppUrls.productionHost + AppUrls.packs);
    var request = http.MultipartRequest("GET", url);
    var response = await request.send();
    var data = await response.stream.transform(utf8.decoder).join();
    details = jsonDecode(data);
    getTemplateImages();
    subscriptionPackCards();
    subscriptionCards = subscriptionCards;
    templateCards = templateCards;
  }

  subscriptionPackCards() {
    for (var index = 0; index < details["SubscriptionData"].length; index++) {
      subscriptionCards.add(
        SizedBox(
          width: double.infinity,
          child: SubscriptionCards(
            month: details["SubscriptionData"][index]["sMonths"],
            title: details["SubscriptionData"][index]["sName"],
            offer: details["SubscriptionData"][index]["sOfferCost"],
            amount: (int.parse(details["SubscriptionData"][index]["sCost"]) /
                    int.parse(details["SubscriptionData"][index]["sMonths"]))
                .round()
                .toString(),
            albums: details["SubscriptionData"][index]["sAlbums"],
            color: index == 0
                ? AppColors.color1
                : index == 1
                    ? AppColors.color2
                    : AppColors.color3,
            onPress: () {
              Get.toNamed(Routes.PAYMENT, arguments: {
                'data': details["SubscriptionData"],
                'index': index,
                'color': index == 0
                    ? AppColors.color1
                    : index == 1
                        ? AppColors.color2
                        : AppColors.color3,
              });
            },
          ),
        ),
      );
    }
  }

  getTemplateImages() {
    for (var i = 0; i < details["TemplateData"].length; i++) {
      templateCards.add(InkWell(
        onTap: () async {
          if (await canLaunchUrl(
              Uri.parse((details["TemplateData"][i]["tURL"])))) {
            launchUrl(details["TemplateData"][i]["tURL"]);
          }
        },
        child: Builder(builder: (context) {
          return Card(
            elevation: 4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: AppUrls.productionHost +
                    AppUrls.templateimages +
                    details["TemplateData"][i]["tImage"],
                fit: BoxFit.fill,
                height: 500,
                width: 500,
              ),
            ),
          );
        }),
      ));
    }
  }

  @override
  void onInit() {
    packs = getpacks();
    super.onInit();
  }
}
