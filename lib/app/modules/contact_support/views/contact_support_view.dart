import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/contact_support_controller.dart';

class ContactSupportView extends GetView<ContactSupportController> {
  const ContactSupportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ContactSupportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ContactSupportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
