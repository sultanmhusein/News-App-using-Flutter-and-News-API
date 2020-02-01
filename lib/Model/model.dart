class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String,dynamic> json)
  {
    return Article(
      source: Source.fromJsonForArticle(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content']
    );
  }
}


class Source {

  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String languange;
  final String country;

  Source({this.id, this.name, this.description, this.url, this.category, this.languange, this.country});


  factory Source.fromJson(Map<String,dynamic> json)
  {
    return Source(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      category: json['category'],
      languange: json['languange'],
      country: json['country']
    );
  }

  factory Source.fromJsonForArticle(Map<String,dynamic> json)
  {
    return Source(
      id: json['id'],
      name: json['name']
    );
  }

}

class NewsAPI{
  final String status;
  final List<Source> sources;

  NewsAPI({this.status, this.sources});

  factory NewsAPI.fromJson(Map<String,dynamic> json)
  {
    return NewsAPI(status: json['status'],
    sources: (json['sources'] as List).map((source)=> Source.fromJson(source)).toList());
  }
}
