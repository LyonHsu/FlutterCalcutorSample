import 'dart:io';

import 'package:flutter/material.dart';
import 'BPage.dart';
import 'CPage.dart';
import 'calcuator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:package_info/package_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'menu_drawer.dart';

void main() {
  runApp(
      EasyLocalization(
          child: MyApp(),
        // 支持的语言
        supportedLocales: [Locale('zh', 'CN'), Locale('en', 'US')],
        // 语言资源包目录
        path: 'resources/langs',
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyon 的Flutter計算機',
      //導入語言包
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,

      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: tr('title')),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;
  String _appVersion = '0.0.0';
  String _calcuator = '0.0';
  double padNum = 2;
  bool isStartCal=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVersion();
  }

  void _setData(String v){
    if(     v==("x")
        ||  v==("+")
        ||  v==("-")
        ||  v==("÷")
        ||  v==("%")
        ||  v==("+/-")
    ){
      isStartCal = true;
    }

    setState(() {
      if(!isStartCal){
        isStartCal = true;
        _calcuator="0.0";
      }
      switch (v){
        case 'C':
          _calcuator = '0.0';
          isStartCal = false;
          break;
        case '<-':
          _calcuator = Calcuator().rmSub(_calcuator);
          break;
        case 'X':
        case 'x':
          _calcuator = '$_calcuator'+'x';
          break;
        case '=':
          isStartCal = false;
          var ssss = _calcuator;
          _calcuator = Calcuator().init(ssss).toString();
          break;
        case '+/-':
          var ssss = _calcuator;
          var list =Calcuator().PositiveAndNegative(ssss);
          _calcuator = list.toString();
          break;
        default :
          if(_calcuator=='0.0'){
            _calcuator = '$v';
          }else
            _calcuator = '$_calcuator'+'$v';
          break;
      }
    });
  }

  void showMyMaterialDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text(tr('app_name')),
            content: new Text(
              tr('title'),
              // 加大字体, 便于演示
              style: TextStyle(fontSize: 30),),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(tr('ok')),
              ),
            ],
          );
        });
  }

  void showChangeLanguageDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        title: Text("Language"),
        children: [
          SimpleDialogOption(
            child: Text("中文"),
            onPressed: (){
              EasyLocalization.of(context).locale = Locale('zh', 'CN');
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text("English"),
            onPressed: (){
              EasyLocalization.of(context).locale = Locale('en', 'US');
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.language), onPressed: ()=>showChangeLanguageDialog(),)
        ],
      ),
      drawer: Drawer(
        child: MenuStatefulWidget()
      ),
      body:SingleChildScrollView(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 10.0), //容器外填充
              padding: EdgeInsets.all(10.0), //容器内补白
              decoration: new BoxDecoration(color: Colors.blue),
              child: new Center(
                child:Text('$_calcuator',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ) ,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('%');
                      },
                      child: Text('%' ,style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('C');
                      },
                      child: Text('C',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('<-');
                      },
                      child: Text('<-',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('÷');
                      },
                      child: Text('÷',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('7');
                      },
                      child: Text('7',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('8');
                      },
                      child: Text('8',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('9');
                      },
                      child: Text('9',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('x');
                      },
                      child: Text('x',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('4');
                      },
                      child: Text('4',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('5');
                      },
                      child: Text('5',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('6');
                      },
                      child: Text('6',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('-');
                      },
                      child: Text('-',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  ////margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('1');
                      },
                      child: Text('1',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  ////margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('2');
                      },
                      child: Text('2',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('3');
                      },
                      child: Text('3',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('+');
                      },
                      child: Text('+',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('.');
                      },
                      child: Text('.',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('0');
                      },
                      child: Text('0',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('+/-');
                      },
                      child: Text('+/-',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  //margin:EdgeInsets.only(left: padNum,right: padNum),
                  child: ButtonTheme(
                    buttonColor: Colors.lightBlue,

                    child: RaisedButton(
                      onPressed: () {
                        _setData('=');
                      },
                      child: Text('=',style: TextStyle(fontSize: 30.0,color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var localVersion = packageInfo.version;
    var buildNumber = packageInfo.buildNumber;
    print('initVersion() localVersion:$localVersion buildNumber=$buildNumber');
    setState(() {
      _appVersion = 'ver:$localVersion($buildNumber)';
    });
  }
}
