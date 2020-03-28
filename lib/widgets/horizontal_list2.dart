import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page.dart';

Widget horizontalList2({List<User> listData, String title, mycontext}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 3),
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
        padding: EdgeInsets.only(right: 10),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: listData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 10),
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 380,
                      child: Row(
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
                                      child: SinglePage(
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
                                maxHeight: 180,
                                maxWidth: 150,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: "${listData[index].image}",
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
                                placeholder: (context, url) => Center(
                                  child: Center(
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
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image),
                              ),
                            ),
                          ),
                          Container(
                            child: Expanded(
                              child: Column(
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
                                              child: SinglePage(
                                                  id: listData[index].id,
                                                  author: listData[index]
                                                      .author_name,
                                                  title: listData[index]
                                                      .post_title,
                                                  image: listData[index].image),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${listData[index].post_title}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${listData[index].post_content}",
                                            style: TextStyle(
                                              fontSize: 11,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, right: 12, bottom: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ArchivePage(
                                                title:
                                                    listData[index].author_name,
                                                type: "author",
                                                value:
                                                    listData[index].author_id,
                                                limit: 10,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${listData[index].author_name}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey),
                                          ),
                                          Icon(
                                            Icons.bookmark_border,
                                            size: 20,
                                          )
                                        ],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
