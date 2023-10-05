import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ygonotebook/app/init.dart';
import 'package:ygonotebook/page/home_page.dart';
import 'package:ygonotebook/widget/debug_float_entry_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  Future<void>? _initApp;

  @override
  void initState() {
    super.initState();
    _initApp = init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _initApp,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return const HomePage();
          }
          return const SizedBox.shrink();
        }
      ),
      builder: (ctx, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return child ?? const SizedBox();
              },
            ),
            DebugOverlayManager.getOverLay(onDoubleClick: () {
              if (navKey.currentContext == null) {
                return;
              }
              showDebugActionSheet(navKey.currentContext!, navState: null);//navKey.currentState);
            }),
          ],
        );
      },
    );
  }
}
