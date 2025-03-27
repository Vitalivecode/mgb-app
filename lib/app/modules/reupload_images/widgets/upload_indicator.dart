import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class UploadIndicator extends StatelessWidget {
  final String uploadText;

  final double percentage;

  final sentBytes;

  final totalBytes;

  const UploadIndicator(
      {super.key,
      required this.uploadText,
      required this.percentage,
      this.sentBytes,
      this.totalBytes});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 30.0,
              animation: true,
              animateFromLastPercent: true,
              linearGradient: LinearGradient(
                  colors: [AppColors.blue.withOpacity(.6), AppColors.darkBlue],
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.mirror),
              arcType: ArcType.FULL,
              addAutomaticKeepAlive: true,
              arcBackgroundColor: AppColors.color1.withOpacity(.1),
              backgroundWidth: 0.0,
              curve: Curves.slowMiddle,
              circularStrokeCap: CircularStrokeCap.round,
              percent: percentage,
              header: Text(uploadText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 23)),
              footer: Text(
                "${(sentBytes * 0.00000095367432).toStringAsFixed(2)} MB / ${(totalBytes * 0.00000095367432).toStringAsFixed(2)} MB",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 18),
              ),
              center: percentage == 1.0
                  ? Icon(
                      Icons.cloud_done,
                      color: AppColors.darkBlue.withOpacity(.6),
                      size: 80,
                    )
                  : Text("${(percentage * 100).toStringAsFixed(1)}%",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 23)),
              backgroundColor: Colors.transparent),
        ),
      ),
    );
  }
}
