import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/Model/model.dart';
import 'package:url_launcher/url_launcher.dart';

String apiKey = 'db2849d4b8da41d1a7bb165c924fc9df';

Future<List<Article>> fetchArticleBySource(String source) async{
  final response = await http.get('https://newsapi.org/v2/top-headlines?sources=$source&apiKey=$apiKey');

  if (response.statusCode == 200) {
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception('Failed to load article list');
  }
}



class ArticleScreen extends StatefulWidget{
  final Source source;

  ArticleScreen({Key key, @required this.source}):super(key:key);



  @override
  State<StatefulWidget> createState() => ArticleScreenState();
  }

class ArticleScreenState extends State<ArticleScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();



  @override
  void initState() {
    refreshListArticle();
  }

    Future<Null> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_articles = fetchArticleBySource(widget.source.id);
    });

    return null;
    }

  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Search Title");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                  ),
            ],
            title: cusSearchBar,
        ),
        body: Center(
          child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Article>>(
              future: list_articles,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text('${snapshot.error}');
                } else if(snapshot.hasData){
                  List<Article> articles = snapshot.data;
                  return Container(
                    color: Colors.blueAccent,
                    child: ListView(
                      children: articles.map((article) => GestureDetector(
                        onTap: (){

                          _launchUrl(widget.source.url);

                        },
                        child: Card(
                          elevation: 1.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
                                width: 100.0,
                                height: 100.0,
                                child: article.urlToImage != null ? Image
                                    .network(article.urlToImage):Image
                                    .asset('assets/Vector.png'),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left:8.0, top:20.0, bottom:10.0),
                                            child: Text(
                                              '${article.title}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '${article.description}',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold
                                          )
                                      ),
                                    )
                                  ],
                                ),)
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  );
                }

                  return CircularProgressIndicator();
              },
            ), 
            onRefresh: refreshListArticle),
        ),
      ),
    );
  }

  _launchUrl(String url) async{
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('Couldn\'t launch $url');
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Please enter a title",
            ),
          )
        ],
      );
    }

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder(
          // stream: InheritedBlocs.of(context).searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List<Article>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(query)
                ],
              );
            } else if (snapshot.data.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                    title: Text(result.title),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}