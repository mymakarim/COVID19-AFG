import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/helper.dart';
import 'package:newschin/model/user.dart';
import 'package:newschin/single/single_page2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../database_provider.dart';
import 'Archive.dart';

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  ApiProvider apiProvider = ApiProvider();

  final _fbKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'comment': '',
    'name': '',
    'desc': '',
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_fbKey.currentState.validate()) {
              _fbKey.currentState.save();
              apiProvider.sendComment(
                name: _formData['name'],
                comment: _formData['comment'],
                desc: _formData['desc'],
              ).then((value){
                if(value == 1){
                  Navigator.pop(context);
                }else{
                  print("Error");
                }
              });
            }
          },
          child: Icon(Icons.save),
        ),
        appBar: AppBar(
          title: Text("یادداشت"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _fbKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Helper().yahyaTextField(
                    formData: _formData,
                    columnName: "name",
                    lableText: "اسم شما",
                    validate: "notNull",
                  ),
                  Helper().yahyaTextArea(
                    columnName: "desc",
                    formData: _formData,
                    labelText: "درمورد شما",
                  ),
                  Helper().yahyaTextArea(
                    labelText: "یادداشت شما",
                    formData: _formData,
                    columnName: "comment"
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
