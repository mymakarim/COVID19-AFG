import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/Archive.dart';
import 'package:newschin/single/single_page2.dart';

Widget horizontalList3({List<User> listData, String title, myContext}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
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
        color: Colors.white,
        padding: EdgeInsets.only(right: 10),
        height: 290,
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
                    padding: const EdgeInsets.only(left: 8),
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 280,
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
                                          author: listData[index].authorName,
                                          title: listData[index].postTitle,
                                          image: listData[index].image),
                                    );
                                  },
                                ),
                              );
                            },
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: 180,
                                  minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width),
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
                                placeholder: (context, url) =>
                                    Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          backgroundColor: Colors.black12,
                                          valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                            Colors.redAccent,
                                          ),
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
                                          child: SinglePage2(
                                              id: listData[index].id,
                                              author:
                                              listData[index].authorName,
                                              title: listData[index].postTitle,
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, right: 12, bottom: 8),
                                child: Text(
                                  "${listData[index].authorName}",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ),
                            ],
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
