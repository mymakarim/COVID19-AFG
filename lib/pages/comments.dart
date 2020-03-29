import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/helper.dart';
import 'package:newschin/model/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../database_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class Comments extends StatefulWidget {
  final type;
  final value;
  final limit;
  final offset;

  const Comments({Key key, this.type, this.value, this.limit, this.offset})
      : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments>
    with AutomaticKeepAliveClientMixin<Comments> {
  DatabaseProvider dbProvider = DatabaseProvider();
  ApiProvider apiProvider = ApiProvider();

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<User> listData = [];
  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments(false);
  }

  void getComments(bool isLoading) async {
    var data = await apiProvider.getComments(
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
    var data = await (new ApiProvider()).getComments(
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
    getComments(true);
//    how to detect load complete - yahya
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
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
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Helper.authorImage,
                    ),
                  ),
                  color: Colors.redAccent,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Text(
                    " ${listData[index].authorName}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    " ${listData[index].postTitle}",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              subtitle: Html(
                data: """
                            ${listData[index].postContent}
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
