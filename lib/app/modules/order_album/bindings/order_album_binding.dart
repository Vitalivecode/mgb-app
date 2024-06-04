import 'package:get/get.dart';

import '../controllers/order_album_controller.dart';

class OrderAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderAlbumController>(
      () => OrderAlbumController(),
    );
  }
}
