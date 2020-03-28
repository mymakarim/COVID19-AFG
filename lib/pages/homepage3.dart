import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/widgets/comment_widget.dart';
import 'package:newschin/widgets/horizontal_list3.dart';
import 'package:newschin/widgets/horizontal_post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../database_provider.dart';

class HomePage3 extends StatefulWidget {
  @override
  _HomePage3State createState() => _HomePage3State();
}

class _HomePage3State extends State<HomePage3>
    with AutomaticKeepAliveClientMixin<HomePage3> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> listData = [];
  List<User> listData2 = [];
  List<User> listData3 = [];
  List<User> listData4 = [];
  List<User> listData5 = [];
  List<User> listData6 = [];

  DatabaseProvider dbProvider = DatabaseProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers(false);
    getUsers2(false);
    getUsers3(false);
    getUsers4(false);
    getUsers5(false);
    getUsers6(false);
  }

  void getUsers(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 3, limit: 3);
    if (mounted)
      setState(() {
        listData.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 3, limit: 3);
    if (mounted)
      setState(() {
        listData.clear();
        listData.addAll(data);
      });
  }

  void getUsers2(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 3, limit: 2);
    if (mounted)
      setState(() {
        listData2.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 3, limit: 2);
    if (mounted)
      setState(() {
        listData2.clear();
        listData2.addAll(data);
      });
  }

  void getUsers3(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 1608, limit: 3);
    if (mounted)
      setState(() {
        listData3.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 1608, limit: 3);
    if (mounted)
      setState(() {
        listData3.clear();
        listData3.addAll(data);
      });
  }

  void getUsers4(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 6, limit: 3);
    if (mounted)
      setState(() {
        listData4.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 6, limit: 3);
    if (mounted)
      setState(() {
        listData4.clear();
        listData4.addAll(data);
      });
  }

  void getUsers5(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 24, limit: 6);
    if (mounted)
      setState(() {
        listData5.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 24, limit: 6);
    if (mounted)
      setState(() {
        listData5.clear();
        listData5.addAll(data);
      });
  }

  void getUsers6(bool isLoading) async {
    var sqliteData =
        await dbProvider.getUsers(type: 'category', value: 5, limit: 6);
    if (mounted)
      setState(() {
        listData6.addAll(sqliteData);
      });

    ApiProvider _api = new ApiProvider();
    var data = await _api.getUsers(type: "category", value: 5, limit: 6);
    if (mounted)
      setState(() {
        listData6.clear();
        listData6.addAll(data);
      });
  }

  void _onRefresh() async {
    getUsers(false);
    getUsers2(false);
    getUsers3(false);
    getUsers4(false);
    getUsers5(false);
    getUsers6(false);
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
          itemCount: 5,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                height: 370,
                child: horizonalList(
                    listData: listData6, title: "خبرها", mycontext: context),
              );
            } else if (index == 1) {
              return SizedBox(
                height: 420,
                child: horizontalPost(
                    listData: listData4, title: "گزارش", mycontext: context),
              );
            } else if (index == 2) {
              return SizedBox(
                height: 355,
                child: horizontalList3(
                    listData: listData5, title: "گزارش", mycontext: context),
              );
            } else if (index == 3) {
              return SizedBox(
                height: 420,
                child: horizontalPost(
                    listData: listData4, title: "گزارش", mycontext: context),
              );
            } else if (index == 4) {
              return SizedBox(
                height: 370,
                child: horizonalList(
                    listData: listData6, title: "خبرها", mycontext: context),
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
