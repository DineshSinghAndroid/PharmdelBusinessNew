import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Default Widget/DefaultWidget.dart';

class ImageHelper extends StatelessWidget{
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final Alignment alignment;

  const ImageHelper({ Key? key,  required this.image, required this.height,  required this.width,  required this.fit,  required this.alignment, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: GlobalKey(),
      filterQuality: FilterQuality.high,
      // maxHeightDiskCache: height.round(),
      // maxWidthDiskCache: width.round(),
      imageUrl: image,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => DefaultWidget.whiteBg(),
      errorWidget: (context, url, error) => DefaultWidget.whiteBg(),
      fadeOutDuration: const Duration(milliseconds: 500),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }
}

class ImageHelperWhiteBg extends StatelessWidget{
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final Alignment alignment;

  const ImageHelperWhiteBg({ Key? key,  required this.image, required this.height,  required this.width,  required this.fit,  required this.alignment, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: GlobalKey(),
      filterQuality: FilterQuality.medium,
      maxHeightDiskCache: height.round(),
      maxWidthDiskCache: width.round(),
      imageUrl: image,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => DefaultWidget.whiteBg(),
      errorWidget: (context, url, error) => DefaultWidget.whiteBg(),
      fadeOutDuration: const Duration(milliseconds: 500),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }
}

class ImageHelperWhiteBgForProfile extends StatelessWidget{
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final Alignment alignment;

  const ImageHelperWhiteBgForProfile({ Key? key,  required this.image, required this.height,  required this.width,  required this.fit,  required this.alignment, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: GlobalKey(),
      filterQuality: FilterQuality.medium,
      maxHeightDiskCache: height.round(),
      maxWidthDiskCache: width.round(),
      imageUrl: image,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) => DefaultWidget.whiteBg(),
      errorWidget: (context, url, error) => DefaultWidget.whiteBg(),
      fadeOutDuration: const Duration(milliseconds: 500),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }
}

