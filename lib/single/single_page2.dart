import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/widgets/horizontal_post.dart';
import 'package:share/share.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class SinglePage2 extends StatefulWidget {
  final id;
  final author;
  final image;
  final title;

  const SinglePage2({Key key, this.id, this.author, this.image, this.title})
      : super(key: key);

  @override
  _SinglePage2State createState() => _SinglePage2State(
      id: this.id, title: this.title, author: this.author, image: this.image);
}

class _SinglePage2State extends State<SinglePage2> {
  final id;
  final title;
  final image;
  final author;

  List<Widget> children = List();

  List<User> listDataSingle = [];
  List<User> listData = [];
  String _shareText = "با دوستان تان شریک سازید!";

//  yahya
  bool _showAppbar = true;
  ScrollController _scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 50; // set bottom bar height

//  end yahya

  _SinglePage2State({this.id, this.title, this.image, this.author});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getUsers();
//    yahya
    myScroll();
  }

//  yahya
  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }

//  end yahya

  void getUser() async {
    ApiProvider _api = new ApiProvider();
    var data =
        await _api.getUser(id: id, title: title, image: image, author: author);
    setState(() {
      listDataSingle.addAll(data);
    });
  }

  void getUsers() async {
    ApiProvider _api = new ApiProvider();
//    related Posts
    var data = await _api.getUsers(type: "category", value: 6, limit: 3);
    setState(() {
      listData.addAll(data);
    });
//    print(listDataSingle[0].categories.toList()[0].);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          controller: _scrollBottomBarController,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 300,
                        minWidth: MediaQuery.of(context).size.width),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 0, top: 20),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.8),
                    ),
                  ),
        (listDataSingle.length > 0)?
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25),
                    onTap: () {},
                    title: Text(
                      widget.author,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("${listDataSingle[0].date}",
                      style: TextStyle(fontSize: 11),),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFFd73e4d),
                      ),
                      child: Text(
                        "${listDataSingle[0].catName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.white),
                      ),
                    ),
                  ): Text(""),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: (listDataSingle.length > 0)
                        ? Html(
                            data: """
                            ${listDataSingle[0].postContent}
            """,
                            //Optional parameters:
                            padding: EdgeInsets.all(8.0),
                            linkStyle: const TextStyle(
                              color: Colors.redAccent,
                              decorationColor: Colors.redAccent,
                              decoration: TextDecoration.underline,
                            ),
                            onLinkTap: (url) async {
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            onImageTap: (src) {
                              print(src);
                            },
                            customTextAlign: (dom.Node node) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "p":
                                    return TextAlign.right;
                                }
                              }
                              return null;
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            backgroundColor: Colors.redAccent,
                            strokeWidth: 1,
                          )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            (MediaQuery.of(context).size.width - 250) / 2,
                        vertical: 10),
                    child: RaisedButton(
                      color: Color(0xFFd73e4d),
                      onPressed: () {
                        setState() {
                          _shareText = "loading...";
                        }

                        Share.share('${listDataSingle[0].url}',
                            subject: 'NewsChin.com');
                      },
                      child: Text(
                        _shareText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 420,
                    child: horizontalPost(
                        listData: listData,
                        title: "مطالب مرتبط",
                        myContext: context),
                  ),
                ],
              ),
              Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {
                        Share.share('${listDataSingle[0].url}',
                            subject: 'NewsChin.com');
                      },
                      tooltip: 'Share',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
