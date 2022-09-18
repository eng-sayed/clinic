import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImagesWidgets extends StatelessWidget {
  NetworkImagesWidgets(
    this.url, {
    Key? key,
    this.fit,
    this.width,
    this.height,
  }) : super(key: key);
  String url;
  double? width;
  double? height;
  BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
        ),
        fit: fit,
        imageUrl: url,
        errorWidget: (context, _, __) => Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
