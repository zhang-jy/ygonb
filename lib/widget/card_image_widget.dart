import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ygonotebook/constant/common_constant.dart';

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({super.key, required this.localPath, this.height});

  final String localPath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(localPath),
      fit: BoxFit.contain,
      width: height != null ? height! * cardAspectRatio : null,
      height: height,
      errorBuilder: (ctx, e, s) {
        return Container(
          width: height != null ? height! * cardAspectRatio : null,
          height: height,
          color: Colors.yellow
        );
      },
    );
  }
}
