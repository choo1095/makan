import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makan/widgets/common_image_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class CommonImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double aspectRatio;

  const CommonImage(
    this.imageUrl, {
    this.width,
    this.height,
    this.aspectRatio = 4 / 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      imageBuilder: (context, imageProvider) => AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            color: Colors.white,
            width: width ?? double.infinity,
            height: height,
          ),
        ),
      ),
      errorWidget: (context, url, error) => AspectRatio(
        aspectRatio: aspectRatio,
        child: CommonImagePlaceholder(
          width: width,
          height: height,
        ),
      ),
    );
  }
}
