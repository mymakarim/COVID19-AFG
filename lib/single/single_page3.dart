import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/widgets/horizontal_post.dart';
import 'package:share/share.dart';

class SinglePage3 extends StatefulWidget {
  final id;
  final author;
  final image;
  final title;

  const SinglePage3({Key key, this.id, this.author, this.image, this.title})
      : super(key: key);

  @override
  _SinglePage3State createState() => _SinglePage3State(
      id: this.id, title: this.title, author: this.author, image: this.image);
}

class _SinglePage3State extends State<SinglePage3> {
  final id;
  final title;
  final image;
  final author;

  List<Widget> children = List();

  List<User> listDataSingle = [];
  List<User> listData = [];
  String _share_text = "با دوستان تان شریک سازید!";

//  yahya
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
  new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 50; // set bottom bar height

//  end yahya

  _SinglePage3State({this.id, this.title, this.image, this.author});

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

    await _content(listDataSingle[0].post_content);
  }

  void getUsers() async {
    ApiProvider _api = new ApiProvider();
//    related Posts
    var data = await _api.getUsers(type: "category", value: 21, limit: 3);
    setState(() {
      listData.addAll(data);
    });
//    print(listDataSingle[0].categories.toList()[0].);
  }

  void _content(String str) async {
    this.children.clear();
    str = str + "❲ ❳";
    var data = await str.split('');
    int c1 = 0;
    int c2 = 0;
    int c3 = 0;
    int i = 0;
    data.forEach((char) {
      if (char == '❲') {
        c2 = i;
        setState(() {
          this.children.add(new SelectableText(
            '${str.substring(c1, c2)}',
            style: TextStyle(fontSize: 14),
          ));
        });
      }
      if (char == '❳') {
        c3 = i;
        String img = str.substring(c2 + 1, c3);
        if (img.startsWith('http')) {
          setState(() {
            this.children.add(ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 50,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: new Image.network(img),
            ));
          });
        }
        c1 = i + 1;
      } else {
        if (i == str.length - 1)
          setState(() {
            this.children.add(new SelectableText(
              '${str.substring(c3 + 1, str.length)}',
              style: TextStyle(fontSize: 17, height: 1.7),
            ));
          });
      }
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: (listDataSingle.length > 0)
            ? SingleChildScrollView(
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
                      imageUrl: listDataSingle[0].image,
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
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.green),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ArchivePage(
                              title: listDataSingle[0].author_name,
                              type: "author",
                              value: listDataSingle[0].author_id,
                              limit: 10,
                              offset: 0,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10, right: 12, bottom: 0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("${listDataSingle[0].author_name}",
                                style: TextStyle(fontSize: 11),),
                              Text(",  "),
                              Text(listDataSingle[0].date,
                                style: TextStyle(fontSize: 11),)
// yahya
//                                      Text(listDataSingle[0].date),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(right: 12, top: 0),
                    title: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (this.children.length > 0)
                          ? this.children
                          : <Widget>[
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        (MediaQuery
                            .of(context)
                            .size
                            .width - 250) / 2,
                        vertical: 10),
                    child: RaisedButton(
                      color: Color(0xFFd73e4d),
                      onPressed: () {
                        setState() {
                          _share_text = "loading...";
                        }

                        Share.share('${listDataSingle[0].url}',
                            subject: 'NewsChin.com');
                      },
                      child: Text(
                        _share_text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 420,
                    child: horizontalPost(
                        listData: listData,
                        title: "بیشتر  بخوانید",
                        mycontext: context),
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
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
