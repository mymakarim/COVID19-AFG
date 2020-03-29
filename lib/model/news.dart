class News {
  final id;
  final postTitle;
  final authorName;
  final authorId;
  final postDate;
  final catId;
  final imageSmall;
  final image;
  final postContent;
  final isBookmarked;

  News(
      {this.id,
      this.postTitle,
      this.authorName,
      this.authorId,
      this.postDate,
      this.catId,
      this.image,
        this.imageSmall,
        this.postContent,
        this.isBookmarked
      });

  factory News.fromMap(dynamic item) {
    return News(
        id: item['id'],
        catId: item['cat_id'],
        postTitle: item['post_title'],
        postDate: item['post_date'],
        authorId: item['author_id'],
        authorName: item['author_name'],
        image: item['image'],
        imageSmall: item['image_small'],
        postContent: item['post_content'],
        isBookmarked: item['isBookmarked']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_title': postTitle,
      'author_name': authorName,
      'author_id': authorId,
      'post_date': postDate,
      'cat_id': catId,
      'image_small': imageSmall,
      'image': image,
      'post_content': postContent,
      'isBookmarked': isBookmarked
    };
  }
}
