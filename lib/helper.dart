import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Helper {
//  Svg Files -
//  You may introduce all your svg files included in pupbspc.yaml here aswell
  static final String heartSvg = 'fonts/heart.svg';
  static final String commentSvg = 'fonts/comment.svg';
  static final String sendSvg = 'fonts/send.svg';
  static final String homeSvg = 'fonts/home.svg';
  static final String trendSvg = 'fonts/trend.svg';
  static final String coronaSvg = 'fonts/corona.svg';

//  Not Important - I included a single author image so i introduced it here
  static final String authorImage =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

//  SvgImage() Function grabs the svg and
//  Then you can use it anywhere you want
  static svgImage({svg, width: 20.0, height: 20.0}) {
    return SizedBox.fromSize(
      size: Size(width, height),
      child: SvgPicture.asset(
        '$svg',
      ),
    );
  }

  Widget yahyaTextField({
    labelText,
    columnName,
    formData,
    validate,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
//        onChanged: (String value) {
        onSaved: (String value) {
          formData['$columnName'] = value;
        },
        validator: (value) {
          if (validate == 'notNull') {
            if (value.isEmpty) {
              return 'لطفا این را پر  نمایید';
            }
          } else if (validate == 'email') {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(value)) {
              return 'Enter Valid Email';
            }
          } else if (validate == 'phone') {
            if (value.length != 10) {
              return 'Mobile Number must be of 10 digit';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          labelText: "$labelText",
          hintText: "$labelText",
          contentPadding: EdgeInsets.all(20),
          alignLabelWithHint: true,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(0),
            ),
          ),
        ),
      ),
    );
  }

  Widget yahyaTextArea(
      {columnName, labelText, formData, validate: "notNull"}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onSaved: (String value) {
          formData['$columnName'] = value;
        },
        maxLines: 3,
        validator: (value) {
          if (validate == 'notNull') {
            if (value.isEmpty) {
              return 'لطفا این را پر  نمایید';
            }
          } else if (validate == 'email') {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(value)) {
              return 'Enter Valid Email';
            }
          } else if (validate == 'phone') {
            if (value.length != 10) {
              return 'Mobile Number must be of 10 digit';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14),
          labelText: "$labelText",
          hintText: "$labelText",
          contentPadding: EdgeInsets.all(20),
          alignLabelWithHint: true,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(0.0),
            ),
          ),
        ),
      ),
    );
  }

}
