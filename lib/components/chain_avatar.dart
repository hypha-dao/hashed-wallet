// ignore_for_file: avoid_redundant_argument_values

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Chain avatar
///
/// This class renders http and asset, image and svg, or just returns a short name
/// with a colored background
class ChainAvatar extends StatelessWidget {
  final String name;
  final String? image;
  final double size;

  const ChainAvatar({
    super.key,
    required this.name,
    this.image,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (image != null) {
      if (image!.startsWith("http")) {
        if (image!.endsWith(".svg")) {
          return SvgPicture.network(image!, fit: BoxFit.contain);
        } else {
          return CachedNetworkImage(imageUrl: image!, fit: BoxFit.contain);
        }
      } else if (image!.startsWith("asset")) {
        if (image!.endsWith(".svg")) {
          return SvgPicture.asset(image!, fit: BoxFit.contain);
        } else {
          return Image.asset(image!);
        }
      }
    }
    final shortName = name.substring(0, 2).toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(shortName),
    );
  }
}
