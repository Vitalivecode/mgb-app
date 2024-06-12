import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/order_details/controllers/order_details_controller.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OrderDetailsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OrderDetailsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
