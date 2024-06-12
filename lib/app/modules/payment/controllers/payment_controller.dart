import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/app/modules/home/repositories/my_gallery_book_repository.dart';
import 'package:mygallerybook/app/routes/app_pages.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/app_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentController extends GetxController {
  int totalamount = 0;
  Razorpay? _razorpay;
  var selectedpack;
  var pack;
  String? btntext = 'Pay Securly';
  Color? mycolor;

  Type get context => BuildContext;

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  Future<void> openCheckout(amount) async {
    final options = {
      'key': 'rzp_live_auFW5yy8TzDkPk',
      'amount': amount * 100,
      'name': 'My Gallerybook!',
      'description': 'My Gallerybook Subscription',
      'prefill': {
        'contact': MyGalleryBookRepository.getCPhone(),
        'email': MyGalleryBookRepository.getCEmail()
      },
      'extrenal': {
        'wallets': ['paytm'],
      },
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      // debugPrint(e);
    }
  }

  bool pay = false;

  buySubscription(String payid) async {
    print(payid);
    final url = Uri.parse(AppUrls.productionHost + AppUrls.payment);
    print(url);

    final request = http.MultipartRequest('POST', url);
    request.fields['cId'] = MyGalleryBookRepository.getCId();
    request.fields['sId'] = selectedpack[pack]['sId'].toString();
    request.fields['sMonths'] = selectedpack[pack]['sMonths'].toString();
    request.fields['sRemainAlbums'] = selectedpack[pack]['sAlbums'].toString();
    request.fields['amountPaid'] =
        int.parse(selectedpack[pack]['sOfferCost']) > 0
            ? selectedpack[pack]['sOfferCost']
            : selectedpack[pack]['sCost'];
    request.fields['transactionID'] = payid;
    print(request.fields);
    final response = await request.send();
    final data = await response.stream.transform(utf8.decoder).join();
    print(data);
    print('StatusCode:${response.statusCode}');
    if (response.statusCode == 200) {
      var details;
      details = jsonDecode(data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('payment', details['payment']['pId'].toString());
    } else {
      final datai = jsonDecode(data);
      print(datai);
      print(response.statusCode);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response.paymentId);
    buySubscription(response.paymentId!);
    AppUtils.flushbarShow(
      AppColors.green,
      'Success:${response.paymentId!}',
      context as BuildContext,
    );
    mycolor = AppColors.green;
    btntext = 'Please Wait';
    pay = true;
    Future.delayed(const Duration(milliseconds: 5000), () {
      Get.toNamed(Routes.HOME);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AppUtils.flushbarShow(
      AppColors.red,
      'ERROR:${response.code}-${response.message!}',
      context as BuildContext,
    );
    mycolor = AppColors.red;
    btntext = 'Try Again';
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppUtils.flushbarShow(
      AppColors.color3,
      'External Wallet${response.walletName!}',
      context as BuildContext,
    );
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print('these are the arguments:::::>  $args');
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selectedpack = args['data'];
    pack = args['index'];
    mycolor = args['color'] as Color;
    print(pack);
    print(selectedpack[pack]['sId']);
  }
}
