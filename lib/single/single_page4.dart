import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/widgets/horizontal_post.dart';
import 'package:share/share.dart';

class SinglePage4 extends StatefulWidget {
  final id;
  final author;
  final image;
  final title;

  const SinglePage4({Key key, this.id, this.author, this.image, this.title})
      : super(key: key);

  @override
  _SinglePage4State createState() => _SinglePage4State(
      id: this.id, title: this.title, author: this.author, image: this.image);
}

class _SinglePage4State extends State<SinglePage4> {
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
  double bottomBarHeight = 50;
  String _share_text = "با دوستان تان شریک سازید!"; // set bottom bar height

//  end yahya

  _SinglePage4State({this.id, this.title, this.image, this.author});

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
              style: TextStyle(fontSize: 14),
                ));
          });
      }
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("برنامه خبری"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: (listDataSingle.length > 0)
            ? SingleChildScrollView(
          padding: EdgeInsets.all(8),
          controller: _scrollBottomBarController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "شنبه 29 حمل 1399 ",
                    style: TextStyle(fontSize: 11),
                  ),
                  Icon(Icons.brightness_1, size: 10,),
                  Text(" ${listDataSingle[0].cat_name}",
                    style: TextStyle(fontSize: 11),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 10),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.3),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 250,
                      minWidth: MediaQuery
                          .of(context)
                          .size
                          .width),
                  child: CachedNetworkImage(
                    imageUrl: listDataSingle[0].image,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.green),
                            ),
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.image),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        title: "انتخاب سردبیر",
                        mycontext: context),
                  ),
                ],
              ),
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
