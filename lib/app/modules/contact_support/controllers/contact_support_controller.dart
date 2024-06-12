import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactSupportController extends GetxController {
  Future<Map>? contactDetails;
  String? phone;
  String? email;

  Future<Map> getContactDetails() async {
    final dio = Dio();

    final res = await dio.get(AppUrls.productionHost + AppUrls.contactSupport);
    final Map data = jsonDecode(res.toString()) as Map;
    phone = data['phoneNo'].toString();
    email = data['emailId'].toString();
    return data;
  }

  List<Map<String, dynamic>> contactData = [
    {
      'title': 'Visit us',
      'icon': FontAwesomeIcons.chrome,
      'color': Colors.teal,
      'subtitle': 'http://mygallerybook.com',
      'url': 'http://mygallerybook.com',
    },
    {
      'title': 'Facebook',
      'icon': FontAwesomeIcons.facebook,
      'color': Colors.blue[400],
      'subtitle': 'https://www.facebook.com/mgb.gallerybook.9',
      'url': 'https://www.facebook.com/mgb.gallerybook.9',
    },
    {
      'title': 'Twitter',
      'icon': FontAwesomeIcons.twitter,
      'color': Colors.blue,
      'subtitle': 'https://twitter.com/mygallerybook1',
      'url': 'https://twitter.com/mygallerybook1',
    },
    {
      'title': 'Instagram',
      'icon': FontAwesomeIcons.instagram,
      'color': Colors.purple,
      'subtitle': 'https://www.instagram.com/mygallery_book',
      'url': 'https://www.instagram.com/mygallery_book',
    },
    {
      'title': 'Youtube',
      'icon': FontAwesomeIcons.youtube,
      'color': Colors.red,
      'subtitle': 'https://www.youtube.com/channel/UCr0nrvnDqAcbovNm67eHH1g',
      'url': 'https://www.youtube.com/channel/UCr0nrvnDqAcbovNm67eHH1g',
    },
    {
      'title': 'Linkedin',
      'icon': FontAwesomeIcons.linkedin,
      'color': Colors.blue[800],
      'subtitle': 'https://www.linkedin.com/in/mygallery-book-3b63941b4',
      'url': 'https://www.linkedin.com/in/mygallery-book-3b63941b4',
    }
  ];

  List<Widget> getContactList() {
    final listUI = <Widget>[];
    for (var i = 0; i < contactData.length; i++) {
      listUI.add(
        InkWell(
          onTap: () => launchUrlString(contactData[i]['url'].toString()),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: ListTile(
              title: Text(contactData[i]['title'].toString()),
              leading: FaIcon(
                contactData[i]['icon'] as IconData,
                color: contactData[i]['color'] as Color,
              ),
              subtitle: Text(
                contactData[i]['subtitle'].toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  @override
  void onInit() {
    contactDetails = getContactDetails();
    super.onInit();
  }
}
