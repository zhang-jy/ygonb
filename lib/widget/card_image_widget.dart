import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ygonotebook/constant/common_constant.dart';

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({super.key, required this.localPath, required this.height});

  final String? localPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (localPath == null || localPath!.isEmpty) {
      return Container(
          width: height * cardAspectRatio,
          height: height,
          color: Colors.grey
      );
    }
    return Image.file(
      File(localPath!),
      fit: BoxFit.contain,
      width: height * cardAspectRatio,
      height: height,
      errorBuilder: (ctx, e, s) {
        return Container(
          width: height * cardAspectRatio,
          height: height,
          color: Colors.grey
        );
      },
    );
  }
}
