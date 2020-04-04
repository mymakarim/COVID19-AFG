import 'package:flutter/material.dart';
import 'package:newschin/pages/Archive.dart';

class Entry {
  final int id;
  final String title;
  final hasChild;
  final List<Entry> children;

  Entry(this.id, this.title, this.hasChild, [this.children = const <Entry>[]]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'hasChild': hasChild,
      'children': children,
    };
  }
}

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.context);

  final Entry entry;
  final BuildContext context;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ArchivePage(
                  title: "Category Archive",
                  type: "category",
                  value: root.id,
                  limit: 10,
                  offset: 0,
                );
              },
            ),
          );
        },
        title: Text(root.title),
      );
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}