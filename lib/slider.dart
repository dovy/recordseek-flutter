import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:RecordSeek/second.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SliderPage extends StatefulWidget {
  final String _url;

  SliderPage(this._url) : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SliderPage> {
  List<Slide> slides = new List();
  Function goToTab;

  getSlides() {
    slides.add(
      new Slide(
        title: "Select URL",
        styleTitle: TextStyle(
            color: Color(0xff507192),
            fontSize: 36,
            fontWeight: FontWeight.bold),
        description:
        "Open any web browser and navigate to the website you would like to share.",
        styleDescription: TextStyle(
            color: Color(0xff444444),
            fontSize: 20.0,
            fontStyle: FontStyle.italic),
        pathImage: 'assets/images/url.png',
        backgroundColor: Color(0xfff5a623),

      ),
    );
    slides.add(
      new Slide(
        title: "Share",
        styleTitle: TextStyle(
            color: Color(0xff507192),
            fontSize: 26.0,
//                  fontWeight: FontWeight.bold,
            fontFamily: 'Roboto'
        ),
        description:
        "Click on `Share` button. Now choose the RecordSeek application from the sharing panel.",
        styleDescription: TextStyle(
            color: Color(0xff444444),
            fontSize: 16.0,
//                  fontStyle: FontStyle.italic,
            fontFamily: 'Roboto'),
        pathImage: 'assets/images/share.png',
        backgroundColor: Color(0xff203152),

      ),
    );
  }

  @override
  void initState() {

    super.initState();
    if (widget._url != null &&validator.url(widget._url)) {
      Future.delayed(Duration(seconds: 0), () async{
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondClass(Uri.decodeFull(widget._url)),
            ));
        setState(() {
          getSlides();
        });

      });
    }
    else{
      setState(() {
        getSlides();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDonePress() {
    this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xff18bc9c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xff18bc9c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xff18bc9c),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 180.0,
                height: 180.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 30.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: slides.length>0?IntroSlider(
              // List slides
              slides: this.slides,

              // Skip button
              renderSkipBtn: this.renderSkipBtn(),
              colorSkipBtn: Color(0x3318bc9c),
              highlightColorSkipBtn: Color(0xff18bc9c),

              // Next button
              renderNextBtn: this.renderNextBtn(),

              // Done button
              renderDoneBtn: this.renderDoneBtn(),
              onDonePress: this.onDonePress,
              colorDoneBtn: Color(0x3318bc9c),
              highlightColorDoneBtn: Color(0xff18bc9c),

              // Dot indicator
              colorDot: Color(0xff18bc9c),
              sizeDot: 11.0,
              typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

              // Tabs
              listCustomTabs: this.renderListCustomTabs(),
              backgroundColorAllSlides: Colors.white,
              refFuncGoToTab: (refFunc) {
                this.goToTab = refFunc;
              },

              // Show or hide status bar
              shouldHideStatusBar: true,

              // On tab change completed
              onTabChangeCompleted: this.onTabChangeCompleted,
            ):new Container()));
  }
}
