import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page2.dart';

Widget horizontalPost({List<User> listData, String title, myContext}) {
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
                  myContext,
                  MaterialPageRoute(
                    builder: (context) {
                      return ArchivePage(
                        title: "آرشیف - کرونا",
                        type: "category",
                        value: 6,
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
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
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
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: SinglePage2(
                                          id: listData[index].id,
                                          author: listData[index].authorName,
                                          title: listData[index].postTitle,
                                          image: listData[index].image),
                                    ),
                                  );
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
                                  color: Colors.redAccent,
                                ),
                                width: 120,
                                height: 100,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${listData[index].image}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              8),
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
                                            backgroundColor: Colors.redAccent,
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.image),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 10),
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
                                          fontSize: 11,),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ArchivePage(
                                                  title: listData[index]
                                                      .authorName,
                                                  type: "author",
                                                  value: listData[index]
                                                      .authorId,
                                                  limit: 10,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "${listData[index].authorName}",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54),
                                        ),
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
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
