import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newschin/api_provider.dart';
import 'package:newschin/helper.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment>
    with AutomaticKeepAliveClientMixin<Comment> {
  ApiProvider apiProvider = ApiProvider();

  File _image;
  String _uploadedFileURL;
  String _uploadFileText = "حالا اپلود کنید";

  final _fbKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'comment': '',
    'name': '',
    'desc': '',
    'img': '',
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
              apiProvider
                  .sendComment(
                name: _formData['name'],
                comment: _formData['comment'],
                desc: _formData['desc'],
                img: _formData['img'],
              )
                  .then((value) {
                if (value == 1) {
                  Navigator.pop(context);
                } else {
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 200,
                        minWidth: 200,
                        maxWidth: 200,
                        maxHeight: 200),
                    child: (_image != null && _uploadedFileURL == null)
                        ? CircleAvatar(
                            backgroundImage: new FileImage(_image),
                            radius: 200.0,
                          )
                        : CachedNetworkImage(
                            imageUrl: (_uploadedFileURL != null)
                                ? _uploadedFileURL
                                : Helper.authorImage,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
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
                                  strokeWidth: 1,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.redAccent),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image),
                          ),
                  ),
                  _image == null
                      ? RaisedButton.icon(
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          label: Text(
                            'انتخاب عکس',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: chooseFile,
                          color: Colors.indigoAccent,
                        )
                      : Container(),
                  _image != null && _uploadedFileURL == null
                      ? RaisedButton.icon(
                          icon: Icon(Icons.file_upload),
                          label: Text(
                            '$_uploadFileText',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: uploadFile,
                          color: Colors.redAccent,
                        )
                      : Container(),
//                      _image != null
//                          ? RaisedButton(
//                        child: Text('Clear Selection'),
//                        onPressed: clearSelection,
//                      )
//                          : Container(),

                  Helper().yahyaTextField(
                    formData: _formData,
                    columnName: "name",
                    labelText: "اسم شما",
                    validate: "notNull",
                  ),
                  Helper().yahyaTextField(
                    formData: _formData,
                    columnName: "desc",
                    labelText: "درباره شما",
                  ),
                  Helper().yahyaTextArea(
                      labelText: "یادداشت شما",
                      formData: _formData,
                      columnName: "comment"),
                  Text(
                      "پس از نمایان شدن یادداشت تان، آنرا با دوستان تان شریک سازید!"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ستوری کنید! پست بگذارید! #یادداشت_من #COVID19-AFG',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    setState(() {
      _uploadFileText = "درحال اپلود...";
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        _formData['img'] = fileURL;
        print("-=================================");
        print("FILEURL: $fileURL");
        print("-=================================");
      });
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
