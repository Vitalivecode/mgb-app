import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mygallerybook/app/modules/payment_history/controllers/payment_history_controller.dart';
import 'package:mygallerybook/core/app_colors.dart';

class PaymentHistoryView extends GetView<PaymentHistoryController> {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              height: height * .10,
              width: width,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Text(
                'Payment History',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: width * .07,
                      fontWeight: FontWeight.w100,
                      letterSpacing: .5,
                    ),
              ),
            ),
            FutureBuilder(
              future: controller.paymentHistoryFuture,
              builder: (BuildContext context, AsyncSnapshot snp) {
                if (snp.hasError) {
                  print(snp.error);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: height * 0.5,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.signal_wifi_off,
                              size: 80,
                              color: AppColors.blue,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Failed To Load the Data Please connect to internet and try again',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snp.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: LinearProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: getPaymentHistoryListUI(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPaymentHistoryListUI() {
    final paymentHisoryListUI = <Widget>[];
    for (var i = 0; i < controller.paymentHistory.length; i++) {
      final date =
          controller.paymentHistory[i]['paymentAt'].split(' ')[0].split('-');
      final formatedDate = date[2] + '-' + date[1] + '-' + date[0];
      paymentHisoryListUI.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Card(
            elevation: 6,
            color: AppColors.blue,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "${controller.paymentHistory[i]["sName"]}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "${controller.paymentHistory[i]["sDescription"]}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Payment Date $formatedDate',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue[50],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, bottom: 10),
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                const Text(
                                  'Rs ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  " ${controller.paymentHistory[i]["amountPaid"]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return paymentHisoryListUI;
  }
}
