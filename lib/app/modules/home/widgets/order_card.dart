import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';
import 'package:mygallerybook/core/reusable_widgets/shimmer_image.dart';

class OrderCard extends StatelessWidget {
  OrderCard({
    required this.color,
    required this.album,
    required this.timages,
    required this.status,
    required this.image1,
    required this.onPress,
    super.key,
    this.image2,
    this.image3,
    this.image4,
  });

  final Color color;
  final String album;
  final int timages;
  final String status;
  final void Function()? onPress;
  final String image1;
  final String? image2;
  final String? image3;
  final String? image4;
  int quantity = 1;
  final String url =
      Uri.parse(AppUrls.productionHost + AppUrls.orderimages).toString();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * .03,
          vertical: width * .04,
        ),
        padding: EdgeInsets.all(width * .02),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(width * .04),
          border: Border.all(color: color, width: width * .008),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      album,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: width * .05,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '$timages Images',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontSize: width * .04),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * .03,
                    vertical: width * .01,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(width * .05),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontSize: width * .04,
                          ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                SizedBox(
                  width: width * .6,
                  height: width * .5,
                  child: _buildImage('$url/$image1', width * .6, width * .5),
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: <Widget>[
                    if (image2 != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(
                            '$url/$image2', width * .25, width * .25),
                      )
                    else
                      const IgnorePointer(),
                    const SizedBox(
                      height: 5,
                    ),
                    if (image3 != null && image4 != null)
                      GestureDetector(
                        onTap: onPress,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              _buildImage(
                                  '$url/$image3', width * .25, width * .25),
                              Container(
                                width: width * .25,
                                height: width * .25,
                                color: AppColors.black.withOpacity(.5),
                                child: Center(
                                  child: Text(
                                    '+${timages - 3}',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const IgnorePointer(),
                    if (image3 != null && image4 == null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(
                            '$url/$image3', width * .25, width * .25),
                      )
                    else
                      const IgnorePointer(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl, double width, double height) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => ShimmerImage(width: width, height: height),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.error, color: Colors.white),
      ),
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
