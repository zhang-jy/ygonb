import 'package:ygonotebook/util/image_util.dart';

late final String localImagePath;

Future<void> init() async {
  localImagePath = await getPictureDir();
}