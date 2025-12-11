import 'package:flutter/material.dart';
import 'package:pop_back_handler/pop_back_handler.dart' show PopBackHandler;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'PopBackHandler Demo', debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PopBackHandler Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'PopBackHandler Demo, 用于解决 iOS 侧滑返回事件不触发 onPopInvokedWithResult 回调的问题, 支持 Android 和 iOS',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PopBackHandlerDemoPage()));
              },
              child: const Text("Test PopBackHandler"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DisabledInterceptPage()));
              },
              child: const Text("Test Disabled Intercept"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Demo page showing PopBackHandler with interception enabled
/// 使用 PopBackHandler 的 demo 页面，拦截返回事件
class PopBackHandlerDemoPage extends StatefulWidget {
  const PopBackHandlerDemoPage({super.key});

  @override
  State<PopBackHandlerDemoPage> createState() => _PopBackHandlerDemoPageState();
}

class _PopBackHandlerDemoPageState extends State<PopBackHandlerDemoPage> {
  Future<bool> _showExitConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Are you sure you want to leave this page?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("OK")),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _handlePopRequest() async {
    final shouldPop = await _showExitConfirmDialog();
    if (shouldPop && mounted) {
      Navigator.pop(context, "pop_result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopBackHandler(
      canPop: false,
      onPopRequested: (didPop, result) {
        debugPrint("canPop : false   didPop: $didPop, result: $result");
        if (!didPop) {
          _handlePopRequest();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("PopBackHandler Demo"),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handlePopRequest),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("En:"),
                Text(
                  "Try system back button (Android) or swipe from edge (iOS).\n\n"
                  "A confirmation dialog will appear before navigating back.",
                ),
                SizedBox(height: 32),
                Text("Zh:"),
                Text(
                  "请尝试使用系统返回按钮（Android）或从屏幕边缘向内滑动（iOS）。"
                  "返回前会弹出确认对话框。",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Demo page showing PopBackHandler with interception disabled
/// 使用 PopBackHandler 的 demo 页面，拦截返回事件禁用
class DisabledInterceptPage extends StatelessWidget {
  const DisabledInterceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBackHandler(
      canPop: true,
      onPopRequested: (didPop, result) {
        // This won't be called when enableInterceptBack is false
        // 当拦截返回事件禁用时，不会调用这个回调
        debugPrint("canPop : true   didPop: $didPop, result: $result");
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Intercept Disabled")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Back interception is disabled.\n\n"
              "System back gesture will work normally without confirmation.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
