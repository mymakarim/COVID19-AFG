import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page4.dart';

Widget gridPost({List<User> listData, String title, mycontext, BuildContext context}) {
  var size = MediaQuery.of(context).size;

  /*24 is for notification bar on Android*/
  final double itemHeight = 200;
  final double itemWidth = size.width / 2;

  return Column(
    children: <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (title != null)
                ? GestureDetector(
              onTap: () {
                Navigator.push(
                  mycontext,
                  MaterialPageRoute(
                    builder: (context) {
                      return ArchivePage(
                        title: title,
                        type: "category",
                        value: listData[0].cat_id,
                        limit: 10,
                        offset: 0,
                      );
                    },
                  ),
                );
              },
              child: SizedBox(
                height: 60,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFf8f9fa),
                        ),
                        child: Text(
                          "$title",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        "مشاهده همه",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
            )
                : Container(),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (MediaQuery
                          .of(context)
                          .size
                          .width / 500),
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: SinglePage4(
                                          id: listData[index].id,
                                          author: listData[index].author_name,
                                          title: listData[index].post_title,
                                          image: listData[index].image),
                                    );
                                  },
                                ),
                              );
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 150,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                "${listData[index].image}",
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
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.black12,
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
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: SinglePage4(
                                              id: listData[index].id,
                                              author: listData[index]
                                                  .author_name,
                                              title: listData[index].post_title,
                                              image: listData[index].image),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    "${listData[index].post_title}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ArchivePage(
                                          title: listData[index].author_name,
                                          type: "author",
                                          value: listData[index].author_id,
                                          limit: 10,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "${listData[index].author_name}",
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 11
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
