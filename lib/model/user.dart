class User {
  final int id;
  final String postTitle;
  final int authorId;
  final String authorName;
  final postContent;
  final String smallImage;
  final String image;
  final String url;
  final String date;
  final int catId;
  final String catName;
  final int isBookmarked;

  User(
      {this.authorName,
      this.smallImage,
      this.id,
      this.postTitle,
      this.authorId,
      this.postContent,
      this.image,
      this.url,
      this.date,
        this.catId,
        this.isBookmarked,
        this.catName
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_title': postTitle,
      'author_name': authorName,
      'author_id': authorId,
      'date': date,
      'cat_id': catId,
      'smallimage': smallImage,
      'image': image,
      'post_content': "$postContent",
      'isBookmarked': isBookmarked,
      'cat_name': catName
    };
  }

  factory User.fromMap(dynamic item, {isBookmarked: 0}) {
    if (isBookmarked == 1) {
      print("Content: ${item['post_content']}");
    }
    return User(
        id: item['id'],
        catId: item['categories'][0]['cid'],
        postTitle: item['post_title'],
        date: item['post_date'],
        authorId: item['post_author'],
        authorName: item['author_name'],
        image: item['image'][0],
        smallImage: item['image_small'],
        url: item['post_link'],
        postContent: item['post_content'],
        isBookmarked: isBookmarked,
        catName: item['categories'][0]['title']
    );
  }
}
