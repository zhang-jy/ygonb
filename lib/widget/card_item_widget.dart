import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ygonotebook/model/ygo_card.dart';
import 'package:ygonotebook/widget/card_image_widget.dart';

class CardItemWidget extends StatelessWidget {

  final YGOCard? card;

  const CardItemWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    if (card == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          if (card!.localImageUrl.isNotEmpty)
            CardImageWidget(localPath: card!.localImageUrl, height: 70,)
            // Image.file(File(card!.localImageUrl))
        ],
      ),
    );
  }
}
