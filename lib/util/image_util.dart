import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ygonotebook/constant/common_constant.dart';

Future<void> copyZipImage2DocDir() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, imgTarName);
  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
    ByteData data = await rootBundle.load(join('assets', 'zip', imgTarName));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
  final String outDirPath = join(documentsDirectory.path, "pics");
  final inputStream = InputFileStream(path);
  final archive = ZipDecoder().decodeBuffer(inputStream);
  for (var file in archive.files) {
    if (file.isFile) {
      final outputStream = OutputFileStream(join(outDirPath, file.name));
      file.writeContent(outputStream);
      outputStream.close();
    }
  }
  File(path).delete();
}

Future<String> getPictureDir() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  return join(documentsDirectory.path, "pics");
}