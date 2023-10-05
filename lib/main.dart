import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ygonotebook/app/init.dart';
import 'package:ygonotebook/service/card_service.dart';
import 'package:ygonotebook/util/init_util.dart';
import 'package:ygonotebook/widget/debug_float_entry_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  // final GlobalKey innerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (ctx, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                // return Container(
                //   key: innerKey,
                //   child: child ?? const SizedBox(),
                // );
                return child ?? const SizedBox();
              },
            ),
            DebugOverlayManager.getOverLay(onDoubleClick: () {
              // final navState = innerKey.currentContext?.findAncestorStateOfType<NavigatorState>();
              if (navKey.currentContext == null) {
                return;
              }
              showDebugActionSheet(navKey.currentContext!, navState: null);//navKey.currentState);
              // showDebugActionSheet(ctx, navState: navState);
            }),
          ],
        );
      },
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

  final CardService _cardService = CardService();

  Future<void> _asyncInit() async {
    setState(() {
      loading = true;
    });
    // await computeIsolate(asyncInitRunner);
    await asyncInitRunner();
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  bool loading = false;

  Future<void>? _initApp;

  @override
  void initState() {
    super.initState();
    _initApp = init();
  }

  @override
  void dispose() {
    super.dispose();
    DebugOverlayManager.remove();
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
          // if (snapshot.connectionState != ConnectionState.done) {
          //   return const Text("loading..");
          // }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // FutureBuilder(
                    //   future: _cardService.getCardById(10000),
                    //   builder: (context, snap) {
                    //     return CardItemWidget(
                    //       card: snap.data
                    //     );
                    //   }
                    // )
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
          // print("click");
          _asyncInit();
        },
        tooltip: 'init db',
        child: const Icon(Icons.downloading),
      ),
    );
  }
}
