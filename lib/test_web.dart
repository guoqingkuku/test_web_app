import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWeb extends StatefulWidget {
  const TestWeb({super.key});

  @override
  State<TestWeb> createState() => _TestWebState();
}

class _TestWebState extends State<TestWeb> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("testAdd",
          onMessageReceived: (JavaScriptMessage message) async {
        debugPrint(
            "JavascriptChannel:method = testAdd message = ${message.message}");
        GFToast.showToast(
          "收到来至web消息:method = testAdd message = ${message.message}",
          context,
          toastPosition: GFToastPosition.CENTER,
          toastDuration: 5,
        );
      })
      ..loadRequest(Uri.parse('http://choo.live'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("测试web页"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              var s = {
                "title": "测试标题",
                "content": "测试内容",
              };
              var prams = json.encoder.convert(s);
              var js = "window.showJsDialog('$prams')";
              controller.runJavaScript(js);
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
