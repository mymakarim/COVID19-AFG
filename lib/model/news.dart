class News {
  final id;
  final post_title;
  final author_name;
  final author_id;
  final post_date;
  final cat_id;
  final image_small;
  final image;
  final post_content;
  final isBookmarked;

  News(
      {this.id,
      this.post_title,
      this.author_name,
      this.author_id,
      this.post_date,
      this.cat_id,
      this.image,
        this.image_small,
        this.post_content,
        this.isBookmarked
      });

  factory News.fromMap(dynamic item) {
    return News(
        id: item['id'],
        cat_id: item['cat_id'],
        post_title: item['post_title'],
        post_date: item['post_date'],
        author_id: item['author_id'],
        author_name: item['author_name'],
        image: item['image'],
        image_small: item['image_small'],
        post_content: item['post_content'],
        isBookmarked: item['isBookmarked']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_title': post_title,
      'author_name': author_name,
      'author_id': author_id,
      'post_date': post_date,
      'cat_id': cat_id,
      'image_small': image_small,
      'image': image,
      'post_content': post_content,
      'isBookmarked': isBookmarked
    };
  }
}
