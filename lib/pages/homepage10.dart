import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/widgets/big_post.dart';
import 'package:newschin/widgets/grid_post.dart';
import 'package:newschin/widgets/comment_widget.dart';
import 'package:newschin/widgets/horizontal_list2.dart';
import 'package:newschin/widgets/horizontal_list3.dart';
import 'package:newschin/widgets/horizontal_post.dart';
import 'package:newschin/widgets/horizontal_post2.dart';

class HomePage10 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans',
        primarySwatch: Colors.green,
      ),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: MyHomePage(title: 'WP News')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> listData = [];
  List<User> listData2 = [];
  List<User> listData3 = [];
  List<User> listData4 = [];
  List<User> listData5 = [];
  List<User> listData6 = [];

  @override
  void initState() {
    super.initState();
    getUsers(false);
    getUsers2(false);
    getUsers3(false);
    getUsers4(false);
    getUsers5(false);
    getUsers6(false);
  }

  void getUsers(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 3, limit: 3);
    print("Data: $data");
    if (mounted)
      setState(() {
        listData.clear();
        listData.addAll(data);
      });
  }

  void getUsers2(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 5, limit: 2);
    if (mounted)
      setState(() {
        listData2.clear();
        listData2.addAll(data);
      });
  }

  void getUsers3(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 1608, limit: 3);
    if (mounted)
      setState(() {
        listData3.clear();
        listData3.addAll(data);
      });
  }

  void getUsers4(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 6, limit: 3);
    if (mounted)
      setState(() {
        listData4.clear();
        listData4.addAll(data);
      });
  }

  void getUsers5(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 24, limit: 6);
    if (mounted)
      setState(() {
        listData5.clear();
        listData5.addAll(data);
      });
  }

  void getUsers6(bool isLoading) async {
    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 5, limit: 6);
    if (mounted)
      setState(() {
        listData6.clear();
        listData6.addAll(data);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Reporterly',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Never Miss an Update",
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.w100),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text("Category One"),
                leading: Icon(Icons.chevron_right),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
//                        minHeight: MediaQuery.of(context).size.height,
                        minHeight: 300,
                        minWidth: MediaQuery.of(context).size.width),
                    child: CachedNetworkImage(
                      imageUrl: "${listData4[0].image}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.image),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 30, left: 20, right: 20, bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${listData4[0].post_title}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        "${listData4[0].author_name}",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.bookmark_border,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 355,
              child: horizontalList3(
                  listData: listData5,
                  title: "ادامه خبرها",
                  mycontext: context),
            ),
            SizedBox(
              height: 495,
              child: horizontalPost2(
                  listData: listData4,
                  title: "طالبان با مردم چه کردند؟",
                  mycontext: context),
            ),
            SizedBox(
              height: 630,
              child: bigPost(
                  listData: listData2, title: "گزارش", mycontext: context),
            ),
            SizedBox(
              height: 370,
              child: horizonalList(
                  listData: listData, title: "ترجمه", mycontext: context),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
