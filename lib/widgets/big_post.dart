import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page2.dart';

Widget bigPost({List<User> listData, String title, mycontext}) {
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
                        title: "آرشیف - آمار کرونا",
                        type: "category",
                        value: 7,
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFd73e4d),
                        ),
                        child: Text(
                          "مشاهده همه",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : Container(),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListView.builder(
                  padding: EdgeInsets.only(right: 8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: new Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                        child: SinglePage2(
                                            id: listData[index].id,
                                            author: listData[index]
                                                .authorName,
                                            title: listData[index]
                                                .postTitle,
                                            image: listData[index].image),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.black12,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: 400,
                                      minWidth:
                                      MediaQuery
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
                              ),
                            ),
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                                            child: SinglePage2(
                                                id: listData[index].id,
                                                author: listData[index]
                                                    .authorName,
                                                title: listData[index]
                                                    .postTitle,
                                                image: listData[index].image),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      "${listData[index].postTitle}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, right: 12, bottom: 8),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "${listData[index]
                                          .authorName} | ${listData[index]
                                          .date}",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ],
  );
}