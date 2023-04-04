import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWeb extends StatefulWidget {
  const TestWeb({super.key, this.titleColor, this.title, required this.url});
  final Color? titleColor;
  final String? title;
  final String url;

  @override
  State<TestWeb> createState() => _TestWebState();
}

class _TestWebState extends State<TestWeb> {
  late WebViewController controller;
  String? title;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) {
          debugPrint("onPageStarted:$url");
        },
        onPageFinished: (_) {
          if (widget.title == null) {
            controller.getTitle().then((value) {
              setState(() {
                title = value;
              });
            });
          }
        },
      ))
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
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: 45,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 45,
                    ),
                    Expanded(
                      child: Text(
                        title ?? "",
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _callWebMethod,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  //调用web的方法
  void _callWebMethod() {
    var s = {
      "title": "测试标题",
      "content": "测试内容",
    };
    var prams = json.encoder.convert(s);
    var js = "window.showJsDialog('$prams')";
    controller.runJavaScript(js);
  }
}
