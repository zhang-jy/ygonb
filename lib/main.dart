import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ygonotebook/page/home_page.dart';
import 'package:ygonotebook/widget/debug_float_entry_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
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
