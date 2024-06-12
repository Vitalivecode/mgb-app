import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/order_album/controllers/order_album_controller.dart';

class OrderAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderAlbumController>(
      OrderAlbumController.new,
    );
  }
}
