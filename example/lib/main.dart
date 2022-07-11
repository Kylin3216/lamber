import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:lamber/lamber.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  // final _lamberPlugin = Lamber();
  final LamberLocalServer server = LamberLocalServer();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    var data = await rootBundle.load("assets/web/web.zip");
    var dir = await getApplicationSupportDirectory();
    print(dir.path);
    var file = File("${dir.path}${Platform.pathSeparator}web.zip");
    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    }
    print(file.existsSync());
    if (file.existsSync()) {
      await lamber.unzip(path: file.path);
      print("unzip ok!!!");
     await server.create("${dir.path}/web/", port: 3000);
      server.start();
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    // try {
    //   platformVersion =
    //       await _lamberPlugin.getPlatformVersion() ?? 'Unknown platform version';
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  @override
  void dispose() {
    server.stop();
    super.dispose();
  }

  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
                onPressed: () {
                  var uri = Uri.parse("http://127.0.0.1:3000");
                  launchUrl(uri);
                },
                icon: Icon(Icons.cached))
          ],
        ),
        body: Text("test"),
        // body: WebView(
        //   initialUrl: "http://localhost:3216",
        //   onWebViewCreated: (ctl) {
        //     controller = ctl;
        //   },
        // ),
      ),
    );
  }
}
