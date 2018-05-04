import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'playerSearch.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('iSquash Grading List'),
        ),
        body: new Center(
          child: new FutureBuilder<List<Player>>(
            future: searchForPlayer(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildPlayerRow(snapshot.data[index]);
                    });
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
