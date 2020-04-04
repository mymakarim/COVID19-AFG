import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newschin/model/dynamic_tab_content.dart';
import 'package:newschin/model/menu.dart';
import 'package:newschin/pages/Author.dart';
import 'package:newschin/pages/comment.dart';
import 'package:newschin/pages/comments.dart';
import 'package:newschin/pages/homepage.dart';
import 'package:newschin/widgets/messaging_widget.dart';

import 'api_provider.dart';
import 'app_localizations.dart';
import 'helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newschin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans',
        primaryColor: Color(0xFFd73e4d),
        accentColor: Colors.white,
      ),
      supportedLocales: [Locale('en', 'US')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return null;
      },
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: MyHomePage(title: 'کرونا افغانستان')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//  TabController _tabController;
  int activeAppBar = 1;
  List<Entry> listMenu = [];

  ApiProvider apiProvider = new ApiProvider();

//  yahya
  List<DynamicTabContent> myList = new List();
  TabController _tabController;

//  herethere
  FirebaseNotifications _firebaseNotifications;
//  herethere
  void subScribeIfNeed() async {

    if (true) {
      _firebaseNotifications.fcmSubscribe();
    }
  }

//  end yahya
  @override
  void initState() {
    super.initState();
    _firebaseNotifications = new FirebaseNotifications();
    _firebaseNotifications.setUpFirebase(context);
    subScribeIfNeed();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFd73e4d),
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Comment();
            }));
          },
          child: Icon(Icons.add, color: Colors.white,),
        ),
//        drawer: Drawer(
//          child: Column(
//            children: <Widget>[
//              DrawerHeader(
//                child: Center(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        'برنامه خبری',
//                        style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 30,
//                          fontWeight: FontWeight.w700,
//                        ),
//                      ),
//                      Text(
//                        "حامی آزادی بیان",
//                        style: TextStyle(
//                            color: Colors.white54, fontWeight: FontWeight.w100),
//                      )
//                    ],
//                  ),
//                ),
//                decoration: BoxDecoration(
//                  color: Color(0xFF31b974),
//                ),
//              ),
//              ListTile(
//                title: Text("HomePage 8"),
//                onTap: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return HomePage8();
//                  }));
//                },
//              ),
//              ListTile(
//                title: Text("HomePage 9"),
//                onTap: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return HomePage9();
//                  }));
//                },
//              ),
//              ListTile(
//                title: Text("HomePage 10"),
//                onTap: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return HomePage10();
//                  }));
//                },
//              ),
//              Expanded(
//                child: ListView.builder(
//                  scrollDirection: Axis.vertical,
//                  itemBuilder: (BuildContext context, int index) =>
//                      EntryItem(listMenu[index], context),
//                  itemCount: listMenu.length,
//                ),
//              )
//            ],
//          ),
//        ),
        appBar: AppBar(
          elevation: 10,
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search),
//              color: Colors.white,
//              onPressed: () {
//                if (mounted)
//                  setState(() {
//                    activeAppBar = 2;
//                  });
//              },
//            ),
//          ],
          title: Text(widget.title),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            indicatorColor: Color(0xFFd73e4d),
            labelPadding: EdgeInsets.all(5),
            labelColor: Theme.of(context).primaryColor,
            labelStyle:
            TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Raleway'),
            tabs: [
              Tab(
                child: Helper.svgImage(svg: Helper.homeSvg),
              ),
              Tab(
                icon: Helper.svgImage(svg: Helper.commentSvg),
              ),
              Tab(
                icon: Icon(Icons.trending_up, color: Colors.black,),
              ),
              Tab(
                icon: Helper.svgImage(svg: Helper.coronaSvg),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            Comments(type: "category", value: 9),
            Author(type: "category", value: 6),
            Author(type: "category", value: 8)
          ],
        ),
      ),
    );
  }
}