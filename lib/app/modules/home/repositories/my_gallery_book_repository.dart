import 'package:sp_util/sp_util.dart';

class MyGalleryBookRepository {
  static String getCId() {
    final cid = SpUtil.getString('cid');
    return cid ?? '';
  }

  static String getCPhone() {
    final cPhone = SpUtil.getString('cPhone');
    return cPhone ?? '';
  }

  static String getCEmail() {
    final cEmail = SpUtil.getString('eMail');
    return cEmail ?? '';
  }

  static String getpId() {
    final pId = SpUtil.getString('pId');
    return pId ?? '';
  }

  static String getaId() {
    final aId = SpUtil.getString('aId');
    return aId ?? '';
  }

  static String getpayId() {
    final payment = SpUtil.getString('payment');
    return payment ?? '';
  }

  static void setUserName(Map<String, dynamic> data) {
    SpUtil.putString('firstName', data['cFName'] ?? '');
    SpUtil.putString('lastName', data['cLName'] ?? '');
  }
}
