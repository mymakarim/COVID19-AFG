import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/single/single_page2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../database_provider.dart';

class Author extends StatefulWidget {
  final type;
  final value;
  final limit;
  final offset;

  const Author({Key key, this.type, this.value, this.limit, this.offset})
      : super(key: key);

  @override
  _AuthorState createState() => _AuthorState();
}

class _AuthorState extends State<Author>
    with AutomaticKeepAliveClientMixin<Author> {

  DatabaseProvider dbProvider = DatabaseProvider();
  ApiProvider apiProvider = ApiProvider();

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<User> listData = [];
  int offset = 0;

  @override
  void initState() {
    super.initState();
    getSqliteData();
    getUsers(false);
  }

  getSqliteData() async {
    var sqliteData = await dbProvider.getUsers(type: widget.type, value: widget.value, limit: 6, offset: offset);
    if(mounted)
    setState(() {
      listData.addAll(sqliteData);
    });
  }

  void getUsers(bool isLoading) async {
    var data = await apiProvider.getUsers(
        type: widget.type,
        value: widget.value,
        limit: widget.limit,
        offset: offset);
    if(mounted)
    setState(() {
      if (!isLoading) {
        listData.clear();
      }
      listData.addAll(data);
    });
  }

  void _onRefresh() async {
    var data = await (new ApiProvider()).getUsers(
        type: widget.type,
        value: widget.value,
        limit: widget.limit,
        offset: 0);
    if (mounted) {
      setState(() {
        listData.clear();
        listData.addAll(data);
        _refreshController.refreshCompleted();
      });
    }
  }

  void _onLoading() async {
    offset += widget.limit;
    getUsers(true);
//    how to detect load complete - yahya
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(backgroundColor: Colors.redAccent, color: Colors.redAccent),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("بالا بکشید");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("خطا! لطفا دوباره امتحان کنید!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("لطفا رها کنید");
            } else {
              body = Text("دیتای بیشتر موجود نیست!");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return (index == 0) ? Container(
              child: Stack(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 300,
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width),
                    child: CachedNetworkImage(
                      imageUrl:
                      "${listData[index].image}",
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder: (context, url) =>
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent),
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return new Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: SinglePage2(
                                      id: listData[index].id,
                                      author: listData[index].authorName,
                                      title: listData[index].postTitle,
                                      image: listData[index].image));
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black
                                ])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 30,
                                    left: 20,
                                    right: 20,
                                    bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${listData[index].postTitle}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        "${listData[index].authorName}",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
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
            ) : Padding(
              padding: EdgeInsets.only(right: 12),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return new Directionality(
                                textDirection: TextDirection.rtl,
                                child: SinglePage2(
                                    id: listData[index].id,
                                    author: listData[index].authorName,
                                    title: listData[index].postTitle,
                                    image: listData[index].image));
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          width: 120,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: "${listData[index].image}",
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) =>
                                Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      valueColor:
                                      new AlwaysStoppedAnimation<Color>(
                                          Colors.redAccent),
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${listData[index].postTitle}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${listData[index].postContent}",
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "${listData[index].authorName}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ));

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
