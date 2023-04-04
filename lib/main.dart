import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_web_app/test_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter web App demo'),
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
  void _openWeb(String url) {
    //调转到新的页面
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TestWeb(
        url: url,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              _buildItem(
                  '去web', 'https://choo.live', "assets/icons/trading.svg"),
              _buildItem(
                  '京东', 'https://www.jd.com', "assets/icons/twitter.svg"),
            ],
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildItem(String title, String url, String icon) {
    return InkWell(
      onTap: () => _openWeb(url),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 80,
              height: 80,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
