import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductButton extends StatelessWidget {
  final String productId;

  const ShareProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final productLink =
            "https://huma-volve-ecommerce.web.app/products/$productId";
        final String shareMessage = "Look at This Product: $productLink";
        await SharePlus.instance.share(
          ShareParams(
            text: shareMessage,
            subject: "Check out this product on Huma Volve",
          ),
        );
      },
      icon: const Icon(Icons.share),
    );
  }
}
