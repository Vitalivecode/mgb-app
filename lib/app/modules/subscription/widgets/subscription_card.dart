import 'package:flutter/material.dart';
import 'package:mygallerybook/app/modules/home/widgets/my_button.dart';
import 'package:mygallerybook/core/app_colors.dart';

class SubscriptionCards extends StatelessWidget {
  const SubscriptionCards({
    required this.color,
    required this.title,
    required this.month,
    required this.offer,
    required this.amount,
    required this.albums,
    required this.onPress,
    super.key,
  });

  final Color color;
  final String title;
  final String month;
  final String amount;
  final String offer;
  final String albums;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(width * .5, height * .33),
                child: SizedBox(
                  width: width * 0.4,
                  height: width * 0.4,
                  child: CustomPaint(
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(width * .5, -height * .2),
                child: SizedBox(
                  width: width * 0.7,
                  height: width * 0.7,
                  child: CustomPaint(
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-width * .6, 0),
                child: SizedBox(
                  width: width * 0.8,
                  height: width * 0.8,
                  child: CustomPaint(
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .09,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Rs. ',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.white,
                                      fontSize: 26,
                                      height: 3,
                                    ),
                          ),
                          if (int.parse(offer) > 0)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Text(
                                amount,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontSize: 23,
                                      decoration: TextDecoration.lineThrough,
                                      height: 2.5,
                                    ),
                              ),
                            )
                          else
                            Container(),
                          Text(
                            int.parse(offer) > 0 ? offer : amount,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white,
                                      fontSize: width * .13,
                                      height: 1.2,
                                    ),
                          ),
                          Text(
                            '/',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white,
                                      fontSize: width * .09,
                                      height: 1.2,
                                    ),
                          ),
                          Text(
                            'month',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white,
                                      fontSize: 18,
                                      height: 2.7,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${int.parse(month) > 1 ? "$month Months" : "$month Month"} validity",
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Text(
                          "$albums (6 X 8 Size) ${int.parse(month) > 1 ? "Photobooks" : "Photobook"}",
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const Text(
                          '1 Photobook per month',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const Text(
                          '(Up to 100 photos)',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Text(
                          'Total Rs. ${(int.parse(offer) > 0 ? int.parse(offer) : int.parse(amount)) * int.parse(month)}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const Text(
                          '(Inclusive Taxes)',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyButton(
                      btntext: 'SELECT',
                      onPress: () {},
                      color: AppColors.white,
                      textcolor: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = AppColors.white1.withOpacity(.1)
    ..strokeWidth = 80
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    required this.color,
    required this.description,
    required this.expiredate,
    required this.onPress,
    super.key,
  });

  final Color color;
  final String description;
  final String expiredate;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(width * .06),
        child: Container(
          width: width * .9,
          height: height * .16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkBlue, AppColors.blue2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(width * .04),
          ),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          'My Subscription Pack',
                          textScaleFactor: 01,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.white,
                                    fontSize: width * .06,
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(height: width * .027),
                    Center(
                      child: Text(
                        description,
                        textScaleFactor: 01,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontSize: width * .04,
                            ),
                      ),
                    ),
                    SizedBox(height: width * .01),
                    Text(
                      'Expire Date : $expiredate',
                      textScaleFactor: 01,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .04,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
