import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/menu.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/single/single_page2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api_provider.dart';

class ArchivePage extends StatefulWidget {
  final title;
  final type;
  final value;
  final limit;
  final offset;

  ArchivePage(
      {Key key,
      this.title: "Archive",
      this.type,
      this.value,
      this.limit,
      this.offset})
      : super(key: key);

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<User> listData = [];
  List<Entry> listCats = [];
  bool isLoading = false;
  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers(false);

  }

  void getUsers(bool isLoading) async {
    var data = await (new ApiProvider()).getUsers(
        type: widget.type,
        value: widget.value,
        limit: widget.limit,
        offset: offset);

//    if return [] then no more loading
    setState(() {
      if (!isLoading) {
        listData.clear();
      }
      listData.addAll(data);
      _refreshController.loadComplete();
    });
  }

  void _onRefresh() async {
    var data = await (new ApiProvider()).getUsers(
        type: widget.type, value: widget.value, limit: widget.limit, offset: 0);
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}"),
          centerTitle: true,
        ),
        body: (listData != null)
            ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
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
//                        minHeight: MediaQuery.of(context).size.height,
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
                                    backgroundColor: Colors.grey,
                                    valueColor:
                                    new AlwaysStoppedAnimation<Color>(
                                        Colors.green),
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
                                          author: listData[index].author_name,
                                          title: listData[index].post_title,
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
                                          "${listData[index].post_title}",
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
                                            "${listData[index].author_name}",
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
                                        author: listData[index].author_name,
                                        title: listData[index].post_title,
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
                                          strokeWidth: 2,
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
                                      "${listData[index].post_title}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${listData[index].post_content}",
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
                                      "${listData[index].author_name}",
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
            ))
            : Center(
            child: Text("done")),
      ),
    );
  }
}
