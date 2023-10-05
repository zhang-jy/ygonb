import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ygonotebook/util/db_util.dart';
import 'package:ygonotebook/util/image_util.dart';

Future<void> initDb() async {
  return copyDb2DocDir();
}

Future<void> initPics() async {
  return copyZipImage2DocDir();
}

Future<dynamic> asyncInitRunner() async {
  await initDb();
  await initPics();
  return 0;
}

Future<dynamic> computeIsolate(Future Function() function) async {
  final receivePort = ReceivePort();
  var rootToken = RootIsolateToken.instance!;
  await Isolate.spawn<_IsolateData>(
    _isolateEntry,
    _IsolateData(
      token: rootToken,
      function: function,
      answerPort: receivePort.sendPort,
    ),
  );
  return await receivePort.first;
}

void _isolateEntry(_IsolateData isolateData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
  final answer = await isolateData.function();
  isolateData.answerPort.send(answer);
}

class _IsolateData {
  final RootIsolateToken token;
  final Function function;
  final SendPort answerPort;

  _IsolateData({
    required this.token,
    required this.function,
    required this.answerPort,
  });
}