import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:share/share.dart';

import '../database_provider.dart';

class SinglePageOffline extends StatefulWidget {
  final id;
  final author;
  final image;
  final title;

  const SinglePageOffline(
      {Key key, this.id, this.author, this.image, this.title})
      : super(key: key);

  @override
  _SinglePageOfflineState createState() => _SinglePageOfflineState(
      id: this.id, title: this.title, author: this.author, image: this.image);
}

class _SinglePageOfflineState extends State<SinglePageOffline> {
  final id;
  final title;
  final image;
  final author;

  List<Widget> children = List();

  List<User> listDataSingle = [];
  List<User> listData = [];

//  yahya
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 50; // set bottom bar height
  String _share_text = "Share it to the social medias!";
  bool isFavorite = false;
  bool isBookmarked = false;

//  end yahya

  _SinglePageOfflineState({this.id, this.title, this.image, this.author});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
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
    DatabaseProvider _dbProvider = new DatabaseProvider();
    var data = await _dbProvider.getUser(id: id);
    setState(() {
      listDataSingle.addAll(data);
    });
    print("CONTENT: ${listDataSingle[0].post_content}");
    await _content(listDataSingle[0].post_content);
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
                  style: TextStyle(fontSize: 16, height: 1.5),
                ));
          });
      }
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              minHeight: 250,
                              minWidth: MediaQuery.of(context).size.width),
                          child: CachedNetworkImage(
                            color: Colors.black12,
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
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 12, right: 12),
                          title: Text(
                            title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                height: 1.3),
                          ),
                          subtitle: GestureDetector(
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
                                  const EdgeInsets.only(top: 12, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.person_outline,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      Text(
                                        author,
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(" - "),
//                                Text(listDataSingle[0].date, style: TextStyle(fontSize: 11),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
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
                                  (MediaQuery.of(context).size.width - 250) / 2,
                              vertical: 10),
                          child: RaisedButton(
                            onPressed: () {
                              setState() {
                                _share_text = "loading...";
                              }

                              Share.share('${listDataSingle[0].url}',
                                  subject: 'NewsChin.com');
                            },
                            child: Text(_share_text),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
//                        actions: <Widget>[
//                          IconButton(
//                            icon: Icon(Icons.share,),
//                            onPressed: () {
//                              Share.share('${listDataSingle[0].url}',
//                                  subject: 'NewsChin.com');
//                            },
//                            tooltip: 'Share',
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.bookmark_border,),
//                            onPressed: () {
//                              Share.share('${listDataSingle[0].url}',
//                                  subject: 'NewsChin.com');
//                            },
//                            tooltip: 'Share',
//                          ),
//                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green[400],
                  strokeWidth: 1,
                ),
              ),
      ),
//      yahya

      bottomNavigationBar: (listDataSingle.length > 0)
          ? _show
              ? Container(
                  height: bottomBarHeight,
                  width: MediaQuery.of(context).size.width,
                  child: BottomAppBar(
                    elevation: 200,
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ArchivePage(
                                          title: listDataSingle[0].cat_name,
                                          type: "category",
                                          value: listDataSingle[0].cat_id,
                                          limit: 10,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "${listDataSingle[0].cat_name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Share.share('${listDataSingle[0].url}',
                                      subject: 'NewsChin.com');
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  (isBookmarked)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  (isBookmarked)
                                      ? isBookmarked = false
                                      : isBookmarked = true;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  color: Colors.white,
                  height: 0,
                  width: MediaQuery.of(context).size.width,
                )
          : null,

//    end yahya
    );
  }
}
