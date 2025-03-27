import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    required this.color,
    required this.description,
    required this.expireDate,
    required this.onPress,
    super.key,
  });

  final Color color;
  final String description;
  final String expireDate;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Container(
        width: width * .9,
        height: height * .16,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.darkBlue,
              AppColors.blue2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(width * .04),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'My Subscription Pack',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: AppColors.white,
                              fontSize: width * .06,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: width * .020),
                  Center(
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .04,
                          ),
                    ),
                  ),
                  SizedBox(height: width * .01),
                  Text(
                    'Expire Date : $expireDate',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white, fontSize: width * .04),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
