import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Copy Link
///
/// Used to display a row with a Hash and a copy Icon at the end

class ShareLinkRow extends StatelessWidget {
  final String label;
  final String link;

  const ShareLinkRow({super.key, required this.label, required this.link});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 16),
        Expanded(
          child: Text(link, overflow: TextOverflow.ellipsis),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          // color: AppColors.white,
          onPressed: () async {
            await Share.share(link);
          },
        )
      ],
    );
  }
}
