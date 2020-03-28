import 'package:flutter/material.dart';

class DynamicTabContent {
  IconData icon;
  String title;
  Widget widget;
  int id;

  DynamicTabContent.name(this.icon, this.title, {this.widget, this.id});
}
