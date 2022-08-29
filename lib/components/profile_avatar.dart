import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// PROFILE AVATAR
///
/// This class works with http, svg images or just returns a short name
/// with a colored background
class ProfileAvatar extends StatelessWidget {
  final double size;
  final String? image;
  final String? nickname;
  final String account;
  final BoxDecoration? decoration;

  const ProfileAvatar({
    super.key,
    this.decoration,
    required this.size,
    this.image,
    this.nickname,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (image != null && image!.startsWith('http')) {
      return CachedNetworkImage(imageUrl: image!, fit: BoxFit.cover);
    } else if (image != null && image!.endsWith('.svg')) {
      return SvgPicture.asset(image!, fit: BoxFit.scaleDown);
    } else if (image != null && image!.startsWith("asset")) {
      return Image.asset(image!);
    } else {
      final shortName =
          nickname != null && nickname!.isNotEmpty && nickname != 'Seeds Account' && nickname != 'Telos Account'
              ? nickname!.substring(0, 2).toUpperCase()
              : account.substring(0, 2).toUpperCase();

      return Container(
        decoration: decoration ??
            BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
        alignment: Alignment.center,
        child: Text(shortName),
      );
    }
  }
}
