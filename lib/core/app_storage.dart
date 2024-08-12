import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mygallerybook/core/app_constants.dart';

class AppStorage extends GetxService {
  // UserInformation? _loggedInUser;
  //
  // UserInformation? get loggedInUser => _loggedInUser;

  // set loggedInUser(UserInformation? value) {
  //   _loggedInUser = value;
  //   write(AppConstants.login, value?.toJson());
  // }

  Future<AppStorage> init() async {
    await GetStorage.init();
    final data = read(AppConstants.login);
    // if (data != null) {
    //   loggedInUser = UserInformation.fromJson(data as Map);
    // }
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    return GetStorage().write(key, value);
  }

  dynamic read(String key) {
    return GetStorage().read<dynamic>(key);
  }

  Future<void> delete(String key) {
    return GetStorage().remove(key);
  }
}
