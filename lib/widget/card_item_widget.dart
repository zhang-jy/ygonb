import 'package:flutter/material.dart';
import 'package:ygonotebook/model/ygo_card.dart';
import 'package:ygonotebook/widget/adapt_constraint_text.dart';
import 'package:ygonotebook/widget/card_image_widget.dart';

class CardItemWidget extends StatelessWidget {

  final YGOCard? card;

  const CardItemWidget({Key? key, this.card}) : super(key: key);

  final itemHeight = 80.0;
  final imageHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xffefefef),
          borderRadius: BorderRadius.circular(8)
      ),
      height: itemHeight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: CardImageWidget(localPath: card?.localImageUrl, height: imageHeight,)
            ),
          ),
          const SizedBox(width: 12,),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: imageHeight
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        "title",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: AdaptConstraintText(
                        text: "desc " * 100,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
