import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ygonotebook/page/debug_page/db_debug_page.dart';
import 'package:ygonotebook/service/card_service.dart';

class DebugFloatEntryWidget extends StatefulWidget {
  const DebugFloatEntryWidget({super.key, this.initOffset, this.floatSize, this.onDoubleClick});

  final Offset? initOffset;
  final Size? floatSize;
  final VoidCallback? onDoubleClick;

  @override
  State<DebugFloatEntryWidget> createState() => _DebugFloatEntryWidgetState();
}

class _DebugFloatEntryWidgetState extends State<DebugFloatEntryWidget> {

  double _top = 0.0;
  double _left = 0.0;
  late Size _screenSize;
  late Size _floatSize;

  @override
  void initState() {
    super.initState();
    _floatSize = widget.floatSize ?? const Size(40.0, 40.0);
  }

  bool initiated = false;

  void initPosition() {
    _screenSize = MediaQuery.of(context).size;
    final defaultInitOffset = Offset(_screenSize.width - _floatSize.width / 2, (_screenSize.height / 2) - _floatSize.height / 2);
    final Offset initOffset = widget.initOffset != null ? widget.initOffset! : defaultInitOffset;
    _top = initOffset.dy;
    _left = initOffset.dx;
  }

  bool inScreen(double left, double top) {
    final simiWidth = _floatSize.width / 2;
    final floatLeftEdge = left - simiWidth;
    final floatRightEdge = left + simiWidth;
    final simiHeight = _floatSize.height / 2;
    final floatTopEdge = top - simiHeight;
    final floatBottomEdge = top + simiHeight;
    if (floatLeftEdge < 0 || floatRightEdge > _screenSize.width) {
      return false;
    }
    if (floatTopEdge < 0 || floatBottomEdge > _screenSize.height) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!initiated) {
      initiated = true;
      initPosition();
    }
    return Stack(
      children: [
        Positioned(
          top: _top,
          left: _left,
          child: Transform.translate(
            offset: Offset(-(_floatSize.width/2), -(_floatSize.height/2)),
            child: GestureDetector(
              onPanUpdate: (details) {
                if (!inScreen(details.globalPosition.dx, details.globalPosition.dy)) {
                  return;
                }
                setState(() {
                  _left = details.globalPosition.dx;
                  _top = details.globalPosition.dy;
                });
              },
              onDoubleTap: widget.onDoubleClick,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: _floatSize.width,
                  height: _floatSize.height,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(max(_floatSize.width, _floatSize.height))
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "D",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
}

class DebugOverlayManager {
  static OverlayEntry _buildOverlay({VoidCallback? onDoubleClick}) {
    return OverlayEntry(builder: (ctx) {
      return DebugFloatEntryWidget(
        floatSize: const Size(50.0, 50.0),
        onDoubleClick: () {
          onDoubleClick?.call();
        },
      );
    });
  }

  static OverlayEntry? _lastOverlay;

  static OverlayEntry getOverLay({VoidCallback? onDoubleClick}) {
    _lastOverlay ??= _buildOverlay(onDoubleClick: onDoubleClick);
    return _lastOverlay!;
  }

  static void insert(BuildContext context, {VoidCallback? onDoubleClick}) {
    _lastOverlay ??= _buildOverlay(onDoubleClick: onDoubleClick);
    Overlay.of(context, rootOverlay: true).insert(_lastOverlay!);
  }

  static void replaceInsert(BuildContext context, {VoidCallback? onDoubleClick}) {
    if (_lastOverlay != null) {
      _lastOverlay!.remove();
      _lastOverlay = null;
    }
    _lastOverlay = _buildOverlay(onDoubleClick: onDoubleClick);
    Overlay.of(context, rootOverlay: true).insert(_lastOverlay!);
  }

  static void remove() {
    _lastOverlay?.remove();
    _lastOverlay = null;
  }

  static String _debugInfo = "";
  static String get debugInfo => _debugInfo.isEmpty ? "None" : _debugInfo;

  static OverlayEntry get _overlayDebugInfo {
    if (_last != null) {
      _last!.remove();
      _last = null;
    }
    return OverlayEntry(builder: (ctx) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          removeDebugInfo();
        },
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              debugInfo
            ),
          ),
        ),
      );
    });
  }

  static OverlayEntry? _last;

  static void insertDebugInfo(BuildContext context, String debugInfo) {
    _debugInfo = debugInfo;
    _last = _overlayDebugInfo;
    Overlay.of(context, rootOverlay: true).insert(_last!);
  }

  static void removeDebugInfo() {
    if (_last != null) {
      _last!.remove();
      _last = null;
    }
  }
}

Future<void> showDebugActionSheet(BuildContext context, {NavigatorState? navState}) async {
  Widget widgetBuilder(BuildContext ctx) {
    return CupertinoActionSheet(
      title: const Text(
        'debug菜单',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black26,
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text(
            '调试页面',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            if (navState != null) {
              await navState.push(
                MaterialPageRoute(builder: (ctx) {
                  return const DebugPage(title: '调试页面',);
                })
              );
              return;
            }
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return const DebugPage(title: '调试页面',);
            }));
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '查询数据库info',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            final desc = await CardService().getCardsTableColumnName();
            if (context.mounted) {
              DebugOverlayManager.insertDebugInfo(context, desc.join("\n"));
              // 关闭菜单
              if (navState != null) {
                navState.pop();
                return;
              }
              Navigator.of(context).pop();
            }
          },
        ),
        CupertinoActionSheetAction(
          child: const Text(
            '通过id查询卡片',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: () async {
            final desc = await CardService().getCardById(10000);
            if (context.mounted) {
              DebugOverlayManager.insertDebugInfo(context, desc.toString());
              // 关闭菜单
              if (navState != null) {
                navState.pop();
                return;
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text(
          '取消',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          // 关闭菜单
          if (navState != null) {
            navState.pop();
            return;
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
  if (navState != null) {
    await navState.push(
      CupertinoModalPopupRoute(
        builder: widgetBuilder,
      ),
    );
    return;
  }
  await showCupertinoModalPopup(
    context: context,
    builder: widgetBuilder
  );
}
