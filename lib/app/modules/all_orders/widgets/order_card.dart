import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mygallerybook/core/app_colors.dart';
import 'package:mygallerybook/core/app_urls.dart';

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
  });

  final Color color;
  final String album;
  final int timages;
  final String status;
  final void Function() onPress;
  final String image1;
  final String? image2;
  final String? image3;
  int quantity = 1;
  final String url =
      Uri.parse(AppUrls.productionHost + AppUrls.orderimages).toString();

  Dio dio = Dio();

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
                  child: Image.network(
                    width: 80,
                    height: 80,
                    '$url/$image1',
                    errorBuilder: (context, error, stackTrace) {
                      // Display a placeholder image or an error message
                      return Image.asset('assets/empty.png');
                    },
                  ),

                  /* decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            "$url/$image1",
                          ))),*/
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  children: <Widget>[
                    if (image2 != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          width: width * .25,
                          height: width * .25,
                          '$url/$image2',
                          errorBuilder: (context, error, stackTrace) {
                            // Display a placeholder image or an error message
                            return Container(
                              width: 80,
                              height: 80,
                              //color: Colors.transparent,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Set the corner radius
                              ),
                            );
                          },
                        ),
                        /* child: CachedNetworkImage(
                              imageUrl: "$url/$image2",
                              width: width * .25,
                              height: width * .25,
                              fit: BoxFit.cover,
                              errorWidget:(context, url, error) => Icon(Icons.error),

                      ),
                            */
                      )
                    else
                      const IgnorePointer(),
                    const SizedBox(
                      height: 05,
                    ),
                    if (image3 != null)
                      GestureDetector(
                        onTap: onPress,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              /* CachedNetworkImage(
                                    imageUrl: "$url/$image3",
                                    width: width * .25,
                                    height: width * .25,
                                    fit: BoxFit.cover,
                                    errorWidget:(context, url, error) => Icon(Icons.error),
                            ),
                                  */
                              Image.network(
                                width: width * .25,
                                height: width * .25,
                                '$url/$image3',
                                errorBuilder: (context, error, stackTrace) {
                                  // Display a placeholder image or an error message
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    //color: Colors.transparent,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ), // Set the corner radius
                                    ),
                                  );
                                },
                              ),
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
                  ],
                ),
              ],
            ),
            //showWidgets(height, width, context)
          ],
        ),
      ),
    );
  }
}
