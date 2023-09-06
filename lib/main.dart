import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:ygonotebook/model/ygo_card.dart';
import 'package:ygonotebook/util/db_util.dart';
import 'package:ygonotebook/util/image_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> dbContents = [];

  void _initDb() {
    copyDb2DocDir();
  }

  void _initPics() {
    copyZipImage2DocDir();
  }

  Future<void> _queryDb() async {
    final tables = await cardsDbTables();
    dbContents..clear()..addAll(tables.rows.map((e) => "$e"));
    setState(() {});
  }

  Future<void> _queryCard1() async {
    final cards = await queryCard1();
    dbContents..clear()..addAll(YGOCard.fromResultSet(cards).map((e) => e.toString()));
    setState(() {});
  }

  File? file;

  Future<void> _loadPic1() async {
    final imageDir = await getPictureDir();
    file = File(join(imageDir, "1.jpeg"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...dbContents.map((e) => Text(
              e,
              style: Theme.of(context).textTheme.headlineMedium,
            ),),
            if (file != null)
              Image.file(file!),
            CupertinoButton(child: const Text("query db"), onPressed: () {
              _queryDb();
            }),
            CupertinoButton(child: const Text("query card1"), onPressed: () {
              _queryCard1();
            }),
            CupertinoButton(child: const Text("load pic1"), onPressed: () {
              _loadPic1();
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _initDb();
          _initPics();
        },
        tooltip: 'init db',
        child: const Icon(Icons.downloading),
      ),
    );
  }
}
