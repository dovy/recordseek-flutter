import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/loading.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class SecondClass extends StatefulWidget {
  final String _url;

  SecondClass(this._url) : super();

  @override
  SecondPageState createState() => SecondPageState();
}



class SecondPageState extends State<SecondClass> {

  bool alreadyEvaluated = false;

  WebViewController _myController;
  bool _loadedPage = false;

  /// Assumes the given path is a text-file-asset.
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadedPage = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text('RecordSeek'),
            centerTitle: true,
            backgroundColor: Color(0xff18bc9c)),

        body: Stack(
          children: <Widget>[
            new WebView(
              initialUrl: widget._url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _myController = controller;
              },
//              onPageStarted: (url) async {
//                if (url.contains("https://recordseek.com/share/")) {
//                  print('Page started: :$url');
//                  setState(() {
//                    _loadedPage = true;
//                  });
//                }
//              },
              onPageFinished: (url) async {
                if (url.contains("https://recordseek.com/share/")) {
                  setState(() {
                    _loadedPage = true;
                  });
                  alreadyEvaluated = true;
                }

                if (!alreadyEvaluated) {
                  print('Page finished loading: $url');
                  String data = await getFileData('assets/js/bookmarklet.js');
                  // Enable JS because we're going to inject some
//                await _jsChanged();
                  _myController.evaluateJavascript(data);
                }
              },
            ),
            _loadedPage == false
                ? Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Loading(
                            indicator: BallScaleIndicator(),
                            size: 50.0,
                            color: Colors.blue),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text('Please Wait...',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blue)),
                        )
                      ],
                    ),
                  )
                : new Container()
          ],
        ));
  }
}
