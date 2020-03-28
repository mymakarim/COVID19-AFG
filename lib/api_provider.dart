import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newschin/model/user.dart';
import 'package:persian_date/persian_date.dart';

import 'database_provider.dart';

import 'dart:async';

class ApiProvider {
  DatabaseProvider db = DatabaseProvider();

  String yahyaTimeAgo(dynamic time) {
    var str_timeago;
    var d = DateTime.parse(time);
    PersianDate persianDate =
    PersianDate(format: 'yyyy-mm-dd hh:nn:ss SSS', gregorian: d.toString());
    str_timeago =
        persianDate.day.toString() + " " + persianDate.monthname.toString();
    return str_timeago;
    // print('faiz: ${d.millisecondsSinceEpoch}');
    // 86400 d.millisecondsSinceEpoch < 8640000000000000
//    if (d.millisecondsSinceEpoch > DateTime.now().subtract(new Duration(hours: 23)).millisecondsSinceEpoch) {
//      str_timeago = timeago
//          .format(d.subtract(new Duration(milliseconds: d.millisecond)), locale: 'fa')
//          .toString();
//    }
  }

  Future<int> sendComment({String name, String desc, String comment}) async {
    final response = await http.post("http://newschin.com/yahya_insert_draft.php", body:{"name": name, "comment": comment, "desc": desc});
    if(response.statusCode == 200){
      return 1;
    }else{
      return 0;
    }
  }

  Future<List<User>> getComments(
      {String type: '', dynamic value: 0, int limit: 6, int offset: 0}) async {
    var args;
    if (type == '') {
      args = "?";
    } else {
      args = '?$type=$value&limit=$limit&offset=$offset';
    }

    var response = await http.get('http://newschin.com/app.php$args');
    List<User> listUsers = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data['posts'].forEach((item) async {
        var newTitle = item['post_title']
            .replaceAll("&#8217;", "’")
            .replaceAll("&#8220;", "“")
            .replaceAll("&#8221;", "”")
            .replaceAll("&#038;", "&")
            .replaceAll("&#8216;", "	‘");
        listUsers.add(
          new User(
              id: item['id'],
              post_title: item['post_excerpt'],
              author_name: newTitle,
              image: item['image'][0],
              author_id: item['post_author'],
              date: yahyaTimeAgo(item['post_date']),
              cat_id: item['categories'][0]['cid'],
              post_content: item['post_content']),
        );
//        insert into sqlite database
        await db.insertNews(table: 'news', news: User.fromMap(item));
      });
      return listUsers;
    }else{
      print("-------===========-----------");
      print("NOT 200");
      print("-------===========-----------");
    }
  }


  Future<List<User>> getUsers(
      {String type: '', dynamic value: 0, int limit: 6, int offset: 0}) async {
    var args;
    if (type == '') {
      args = "?";
    } else {
      args = '?$type=$value&limit=$limit&offset=$offset';
    }

    var response = await http.get('http://newschin.com/app.php$args');
    List<User> listUsers = [];

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      data['posts'].forEach((item) async {
        var newTitle = item['post_title']
            .replaceAll("&#8217;", "’")
            .replaceAll("&#8220;", "“")
            .replaceAll("&#8221;", "”")
            .replaceAll("&#038;", "&")
            .replaceAll("&#8216;", "	‘");
        listUsers.add(
          new User(
              id: item['id'],
              post_title: newTitle,
              author_name: item['author_name'],
              image: item['image'][0],
              author_id: item['post_author'],
              date: yahyaTimeAgo(item['post_date']),
              cat_id: item['categories'][0]['cid'],
              post_content: item['post_excerpt']),
        );
//        insert into sqlite database
        await db.insertNews(table: 'news', news: User.fromMap(item));
      });
      return listUsers;
    }else{
      print("-------===========-----------");
      print("NOT 200");
      print("-------===========-----------");
    }
  }

  Future<void> bookmark({id}) async {
    try {
      var response =
      await http.get('http://newschin.com/app.php?post_id=$id');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        data['posts'].forEach((item) async {
          print("ON INSERTING: ${item['post_content']}");
          await db.insertNews(
            table: 'bookmarks',
            news: User(
                id: item['id'],
                post_title: item['post_title']
                    .replaceAll("&#8217;", "’")
                    .replaceAll("&#8220;", "“")
                    .replaceAll("&#8221;", "”")
                    .replaceAll("&#038;", "&")
                    .replaceAll("&#8216;", "	‘"),
                author_name: item['author_name'],
                author_id: item['post_author'],
                post_content: item['post_content'],
                image: item['image'][0],
                url: item['post_link'],
                date: yahyaTimeAgo(item['post_date']),
                cat_name: item['categories'][0]['title']),
          );
        });
      }
    } catch (e) {
      throw Exception(e);
    }
//    await db.insertNews(news: User.fromMap(single, isBookmarked: 1));
  }

  Future<List<User>> getUser({id, title, image, author, cat_id}) async {
    try {
      var response =
      await http.get('http://newschin.com/app.php?post_id=$id');
      List<User> listUser = [];

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        data['posts'].forEach((item) {
          listUser.add(
            new User(
                id: item['id'],
                post_title: item['post_title']
                    .replaceAll("&#8217;", "’")
                    .replaceAll("&#8220;", "“")
                    .replaceAll("&#8221;", "”")
                    .replaceAll("&#038;", "&")
                    .replaceAll("&#8216;", "	‘"),
                author_name: item['author_name'],
                author_id: item['post_author'],
                post_content: item['post_content'],
                image: item['image'][0],
                url: item['post_link'],
                date: yahyaTimeAgo(item['post_date']),
                cat_name: item['categories'][0]['title']),
          );
        });
        return listUser;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
