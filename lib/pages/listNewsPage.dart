import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/Model/articleScreen.dart';
import 'package:news_app/Model/model.dart';


String apiKey = 'db2849d4b8da41d1a7bb165c924fc9df';

Future<List<Source>> fetchNewsSource() async{
  final response = await http.get('https://newsapi.org/v2/sources?apiKey=$apiKey');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else {
    throw Exception('Failed to load source list');
  }
}

void main() => runApp(new SourceScreen());

class SourceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SourceScreenState();
}

class SourceScreenState extends State<SourceScreen>{
  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('News App'),),
        body: Center(
          child: RefreshIndicator(
            key: refreshKey,
            child: FutureBuilder<List<Source>>(
              future: list_sources,
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Text('Error: ${snapshot.error}');
                } else if(snapshot.hasData){
                  List<Source> sources = snapshot.data;
                  return Container(
                    color: Colors.blueAccent,
                    child: new ListView(
                      
                      children: sources.map((source)=> GestureDetector(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen(source: source)));

                        },
                          child: Card(
                            elevation: 1.0,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: 20.0),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 100.0,
                                  height: 140.0,
                                  child: Image.asset("assets/newspaper.png"),
                                ),
                                  SizedBox(width: 20.0), //Container
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                              child: Text(
                                                '${source.name}',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                            ), 
                                          )
                                        ],
                                      ),

                                      Container(
                                        child: Text('${source.description}', style: TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.bold)),
                                      ),

                                      Container(
                                        child: Text('Category: ${source.category}', style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                ),

                              ], 
                            ),
                          ), 
                      )).toList()),
                  );
                }

                return CircularProgressIndicator();
              },
            )
          , onRefresh: refreshListSource),
        ),
      ),
    );
  }

  Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsSource();
    });

    return null;
  }
}


