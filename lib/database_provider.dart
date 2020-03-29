import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/menu.dart';
import 'model/user.dart';

class DatabaseProvider {

  final Future<Database> database = openDatabase(
    // Set the path to the database.
    join(getDatabasesPath().toString(), 'corona.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute('''
          CREATE TABLE IF NOT EXISTS news (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          post_title TEXT,
          author_id INTEGER,
          author_name TEXT,
          date TEXT,
          cat_id INTEGER,
          smallimage TEXT,
          image TEXT,
          post_content TEXT,
          url TEXT,
          isBookmarked INTEGER,
          cat_name VARCHAR
          )
        ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS bookmarks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          post_title TEXT,
          author_id INTEGER,
          author_name TEXT,
          date TEXT,
          cat_id INTEGER,
          smallimage TEXT,
          image TEXT,
          post_content TEXT,
          url TEXT,
          isBookmarked INTEGER,
          cat_name VARCHAR
          )
        ''');
      await db.execute('''
          CREATE TABLE IF NOT EXISTS menu (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          hasChild INTEGER
          )
        ''');
//        await db.execute("DROP TABLE news");
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  Future<List<User>> getUsers(
      {String type: '', int value, int limit: 10, int offset: 0}) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM news WHERE cat_id=$value ORDER BY date DESC LIMIT $limit OFFSET $offset');
    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User(
          id: maps[i]['id'],
          catId: value,
          authorId: maps[i]['author_id'],
          authorName: maps[i]['author_name'],
          date: maps[i]['post_date'],
          postTitle: maps[i]['post_title'],
          url: maps[i]['url'],
          smallImage: maps[i]['smallimage'],
          image: maps[i]['image']);
    });
  }

  Future<List<User>> getUser({id}) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM news WHERE id=$id');
    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      print("POSTCONTENTFROMDB: ${maps[i]['post_content']}");
      return User(
          id: maps[i]['id'],
          catId: maps[i]['cat_id'],
          authorId: maps[i]['author_id'],
          authorName: maps[i]['author_name'],
          date: maps[i]['post_date'],
          postTitle: maps[i]['post_title'],
          image: maps[i]['image'],
          catName: maps[i]['cat_name'],
          isBookmarked: maps[i]['isBookmarked'],
          postContent: maps[i]['post_content']);
    });
  }

  Future<List<User>> getBookmarked({limit: 10, offset: 0}) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
    await db.rawQuery(
        'SELECT * FROM bookmarks ORDER BY date DESC LIMIT $limit OFFSET $offset');
    // Convert the List<Map<String, dynamic> into a List<User>.
    return List.generate(maps.length, (i) {
      return User(
          id: maps[i]['id'],
          catId: maps[i]['cat_id'],
          authorId: maps[i]['author_id'],
          authorName: maps[i]['author_name'],
          date: maps[i]['post_date'],
          postTitle: maps[i]['post_title'],
          image: maps[i]['image'],
          catName: maps[i]['cat_name'],
          isBookmarked: maps[i]['isBookmarked'],
          postContent: maps[i]['post_content']);
    });
  }

  Future<void> insertNews({String table, User news}) async {
    final Database db = await database;
    await db.insert(
      '$table',
      news.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMenu({Entry menu}) async {
    final Database db = await database;
    await db.rawQuery(
        "REPLACE INTO menu (title,hasChild) VALUES ('${menu.title}', 0)");
  }

  Future<List<Entry>> getMenu() async {
    // Get a reference to the database.
    final Database db = await database;
    List<Entry> listMenu = [];

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
    await db.rawQuery('SELECT * FROM menu');
    // Convert the List<Map<String, dynamic> into a List<User>.
    maps.forEach((map) {
      listMenu.add(Entry(map['id'], map['title'], false));
    });
    return listMenu;
  }
}
