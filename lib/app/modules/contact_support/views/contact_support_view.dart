import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/contact_support/controllers/contact_support_controller.dart';
import 'package:mygallerybook/app/modules/contact_support/widgets/contact_error.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactSupportView extends GetView<ContactSupportController> {
  const ContactSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(160),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/App_Icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 20),
              child: Container(
                child: const Text(
                  'Contact Us :',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ),
            ),
            FutureBuilder(
              future: controller.contactDetails,
              builder: (context, AsyncSnapshot snp) {
                if (snp.hasError) {
                  return ContactError(height: height);
                } else if (snp.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (await launchUrlString(
                              "mailto:${controller.email ?? ""}",
                            )) {
                              await launchUrlString(
                                "mailto:${controller.email ?? ""}",
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: ListTile(
                              title: const Text('Mail us at'),
                              leading: const FaIcon(
                                FontAwesomeIcons.envelope,
                                color: Colors.blueGrey,
                              ),
                              subtitle: Text(
                                controller.email ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (await canLaunch(
                              "tel:${controller.phone ?? ""}",
                            )) {
                              await launch("tel:${controller.phone ?? ""}");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: ListTile(
                              title: const Text('Call us'),
                              leading: const FaIcon(
                                FontAwesomeIcons.phoneAlt,
                                color: Colors.green,
                              ),
                              subtitle: Text(
                                controller.phone ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 30),
              child: Column(
                children: controller.getContactList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
