import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Future<Quote> quote;

  MyApp({Key key, this.quote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote of the Day'),
        ),
        body: Center(
          child: FutureBuilder<Quote>(
            future: getQuote(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {                
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.quote),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(" - ${snapshot.data.author}"),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }


  Future<Quote> getQuote() async {
    String url = 'https://quotes.rest/qod.json';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});


    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class Quote {
  final String author;
  final String quote;

  Quote({this.author, this.quote});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        author: json['contents']['quotes'][0]['author'],
        quote: json['contents']['quotes'][0]['quote']);
  }
}
