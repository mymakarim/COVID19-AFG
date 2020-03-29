import 'package:flutter/material.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/pages/comment.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../helper.dart';

Widget horizontalList({List<User> listData, String title, myContext}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      (title != null)
          ? GestureDetector(
        onTap: () {},
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
                GestureDetector(
                  onTap: (){
                    Navigator.push(myContext, MaterialPageRoute(builder: (context) {
                      return Comment();
                    }));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 25, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFFd73e4d),
                    ),
                    child: Text(
                      "نظر بدهید",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Colors.white
                      ),
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
        height: 400,
        color: Colors.white,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      Helper.authorImage,
                    ),
                  ),
                  color: Colors.redAccent,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Text(
                    " ${listData[index].authorName}",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    " ${listData[index].postTitle}",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              subtitle: Html(
                data: """
                            ${listData[index].postContent}
            """,
                //Optional parameters:
                padding: EdgeInsets.all(8.0),
                linkStyle: const TextStyle(
                  color: Colors.redAccent,
                  decorationColor: Colors.redAccent,
                  decoration: TextDecoration.underline,
                ),
                onLinkTap: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                onImageTap: (src) {
                  print(src);
                },
                customTextAlign: (dom.Node node) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "p":
                        return TextAlign.right;
                    }
                  }
                  return null;
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
    ],
  );
}
