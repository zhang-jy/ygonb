import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:ygonotebook/app/init.dart';
import 'package:ygonotebook/model/ygo_card.dart';
import 'package:ygonotebook/service/card_service.dart';
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
  File? file;
  final CardService _cardService = CardService();

  Future<void> _initDb() async {
    return copyDb2DocDir();
  }

  Future<void> _initPics() async {
    return copyZipImage2DocDir();
  }

  Future<void> _queryDb() async {
    final columnNames = await _cardService.getCardsTableColumnName();
    dbContents..clear()..addAll(columnNames);
    setState(() {});
  }

  Future<void> _queryCard10000AllColumn() async {
    final columnNames = await _cardService.queryCardAllColumnById(10000);
    if (columnNames == null || columnNames.isEmpty) {
      return;
    }
    dbContents..clear()..add(columnNames);
    setState(() {});
  }

  Future<void> _queryCard10000() async {
    final card = await _cardService.getCardById(10000);
    if (card == null) {
      return;
    }
    dbContents..clear()..addAll([card.toString()]);
    file = File(card.localImageUrl);
    setState(() {});
  }

  bool loading = false;

  Future<void>? _initApp;

  @override
  void initState() {
    super.initState();
    _initApp = init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _initApp,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Text("loading..");
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      _queryCard10000();
                    }),
                    CupertinoButton(child: const Text("query card1 all"), onPressed: () {
                      _queryCard10000AllColumn();
                    }),
                  ],
                ),
              ),
              if (loading)
                const Center(
                  child: Text(
                    "loading..."
                  ),
                )
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            loading = true;
          });
          await _initDb();
          await _initPics();
          setState(() {
            loading = false;
          });
        },
        tooltip: 'init db',
        child: const Icon(Icons.downloading),
      ),
    );
  }
}
