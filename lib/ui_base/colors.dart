import 'package:flutter/cupertino.dart';

class AppColor {
  final Color lightColor;
  final Color darkColor;
  final String tag;

  AppColor(this.lightColor, this.darkColor, this.tag);

  @override
  String toString() {
    return 'AppColor{lightColor: $lightColor, darkColor: $darkColor, tag: $tag}';
  }

  Color resolve(BuildContext context) {
    return CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
      color: lightColor,
      darkColor: darkColor), context);
  }
}

Map<String, AppColor> _colors = <String, AppColor>{}
  ..addEntries(<AppColor>[

  ].map((e) => MapEntry(e.tag, e)));

extension Colors on BuildContext {

}

extension ColorParser on String {
  AppColor? get color => _colors[this];
}