import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page2.dart';

Widget horizontalPost2({List<User> listData, String title, myContext}) {
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
                        title: title,
                        type: "category",
                        value: listData[0].catId,
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
              decoration: BoxDecoration(color: Colors.white),
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      author: listData[index].authorName,
                                      title: listData[index].postTitle,
                                      image: listData[index].image),
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: ListTile(
                                  title: Text(
                                    "${listData[index].postTitle}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
//                                  subtitle: Text(
//                                    "${listData[index].post_content}",
//                                    style: TextStyle(
//                                      fontSize: 11
//                                    ),
//                                    maxLines: 1,
//                                    overflow: TextOverflow.ellipsis,
//                                  ),
                                  trailing: Container(
                                    color: Colors.grey,
                                    width: 100,
                                    height: 100,
                                    child: CachedNetworkImage(
                                      imageUrl: "${listData[index].smallImage}",
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
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.image),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ArchivePage(
                                    title: listData[index].authorName,
                                    type: "author",
                                    value: listData[index].authorId,
                                    limit: 10,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "${listData[index].authorName}",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ),
                        subtitle: Text(
                          "${listData[index].date}",
                          style: TextStyle(fontSize: 11),
                        ),
                        trailing: Icon(Icons.bookmark_border),
                      )
                    ],
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