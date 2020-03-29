import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/widgets/ad.dart';
import 'package:newschin/widgets/big_post.dart';
import 'package:newschin/widgets/horizontal_list3.dart';
import 'package:newschin/widgets/comment_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../database_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<User> listData = [];
  List<User> listData1 = [];
  List<User> listData2 = [];
  List<User> listData3 = [];
  List<User> listData4 = [];

  DatabaseProvider dbProvider = DatabaseProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers(false);
  }

  void getUsers(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 6, limit: 6);
    if (mounted)
      setState(() {
        listData.addAll(sqliteData);
      });
    var sqliteData1 =
    await dbProvider.getUsers(type: 'category', value: 7, limit: 1);
    if (mounted)
      setState(() {
        listData1.addAll(sqliteData1);
      });
    var sqliteData2 =
    await dbProvider.getUsers(type: 'category', value: 8, limit: 6);
    if (mounted)
      setState(() {
        listData2.addAll(sqliteData2);
      });
    var sqliteData3 =
    await dbProvider.getUsers(type: 'category', value: 9, limit: 6);
    if (mounted)
      setState(() {
        listData3.addAll(sqliteData3);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 6, limit: 6);
    if (mounted)
      setState(() {
        listData.clear();
        listData.addAll(data);
      });

    var data1 = await _api.getUsers(type: "category", value: 7, limit: 1);
    if (mounted)
      setState(() {
        listData1.clear();
        listData1.addAll(data1);
      });

    var data2 = await _api.getUsers(type: "category", value: 8, limit: 6);
    if (mounted)
      setState(() {
        listData2.clear();
        listData2.addAll(data2);
      });

    var data3 = await _api.getComments(type: "category", value: 9, limit: 2);
    if (mounted)
      setState(() {
        listData3.clear();
        listData3.addAll(data3);
      });

    var data4 = await _api.getComments(type: "category", value: 10, limit: 1);
    if (mounted)
      setState(() {
        listData4.clear();
        listData4.addAll(data4);
      });

  }

  void _onRefresh() async {
    getUsers(false);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(),
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
              height: 0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 550,
                child: bigPost(
                    listData: listData1, title: "آمار", mycontext: context),
              );
            }else if (index == 1) {
              return SizedBox(
                height: 355,
//              ===================================================
//              I manually changed the cid to 6 for corona news
//              ===================================================
                child: horizontalList3(
                    listData: listData, title: "کرونا نیوز", mycontext: context),
              );
            }else if (index == 2) {
              return SizedBox(
                height: 360,
                child: ads(
                    listData: listData4, title: "تبلیغات", mycontext: context),
              );
            }else if (index == 3) {
              return SizedBox(
                height: 470,
                child: horizonalList(
                    listData: listData3, title: "یادداشت شما", mycontext: context),
              );
            }else if (index == 4) {
              return SizedBox(
                height: 355,
                child: horizontalList3(
                    listData: listData2, title: "پیشگیری", mycontext: context),
              );
            }else if (index == 5) {
              return SizedBox(
                height: 360,
                child: ads(
                    listData: listData4, title: "تبلیغات", mycontext: context),
              );
            }
            return null;
          },
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
