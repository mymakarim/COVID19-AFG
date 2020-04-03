import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/single/single_page2.dart';

Widget ads({List<User> listData, String title, myContext}) {
  return Column(
    children: <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (title != null)
                ? GestureDetector(
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
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: (listData.length > 0)
                  ? Container(
                      color: Colors.black12,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 340,
                            minWidth: MediaQuery.of(myContext).size.width),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              myContext,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: SinglePage2(
                                        id: listData[0].id,
                                        author: listData[0]
                                            .authorName,
                                        title: listData[0]
                                            .postTitle,
                                        image: listData[0].image),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.black12,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: 320,
                                  minWidth:
                                  MediaQuery
                                      .of(myContext)
                                      .size
                                      .width),
                              child: CachedNetworkImage(
                                imageUrl:
                                "${listData[0].image}",
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
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.redAccent,
                        strokeWidth: 1,
                      ),
                    ),
            )
          ],
        ),
      ),
    ],
  );
}
