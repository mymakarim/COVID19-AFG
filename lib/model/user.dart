class User {
  final int id;
  final String post_title;
  final int author_id;
  final String author_name;
  final post_content;
  final String smallimage;
  final String image;
  final String url;
  final String date;
  final int cat_id;
  final String cat_name;
  final int isBookmarked;

  User(
      {this.author_name,
      this.smallimage,
      this.id,
      this.post_title,
      this.author_id,
      this.post_content,
      this.image,
      this.url,
      this.date,
        this.cat_id,
        this.isBookmarked,
        this.cat_name
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_title': post_title,
      'author_name': author_name,
      'author_id': author_id,
      'date': date,
      'cat_id': cat_id,
      'smallimage': smallimage,
      'image': image,
      'post_content': "$post_content",
      'isBookmarked': isBookmarked,
      'cat_name': cat_name
    };
  }

  factory User.fromMap(dynamic item, {isBookmarked: 0}) {
    if (isBookmarked == 1) {
      print("Content: ${item['post_content']}");
    }
    return User(
        id: item['id'],
        cat_id: item['categories'][0]['cid'],
        post_title: item['post_title'],
        date: item['post_date'],
        author_id: item['post_author'],
        author_name: item['author_name'],
        image: item['image'][0],
        smallimage: item['image_small'],
        url: item['post_link'],
        post_content: item['post_content'],
        isBookmarked: isBookmarked,
        cat_name: item['categories'][0]['title']
    );
  }
}
