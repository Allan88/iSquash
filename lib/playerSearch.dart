import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Player {
  final int id;
  final String name;
  final String gender;
  final String squashCode;
  final String grade;
  final int points;

  Player(
      {this.id,
      this.name,
      this.gender,
      this.squashCode,
      this.grade,
      this.points});

  factory Player.fromJson(Map<String, dynamic> json) {
    return new Player(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      squashCode: json['squashCode'],
      grade: json['grade'],
      points: json['points'],
    );
  }
}

Future<List<String>> getValidParameters() async {
  final response = await http.get('https://www.squash.org.nz/sit/ws/cgl/init');
  final responseJson = json.decode(response.body);

  print(responseJson);

  return null;
}

Future<List<Player>> searchForPlayer(
    {String name = '',
    String age = 'Any',
    String club = 'All',
    String district = 'All',
    String gender = 'Both',
    String grade = 'Any',
    String statsGender = 'Both'}) async {
  getValidParameters();
  // Get the search results from the server
  final response =
      await http.post('https://www.squash.org.nz/sit/ws/cgl/search',
          headers: {
            'Accept': 'application/json, text/plain, */*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Content-Type': 'application/json;charset=UTF-8',
            'Host': 'www.squash.org.nz',
            'Origin': 'https://www.squash.org.nz'
          },
          body: json.encode({
            'name': name,
            'age': age,
            'club': club,
            'district': district,
            'gender': gender,
            'grade': grade,
            'statsGender': statsGender
          }));
  final responseJson = json.decode(response.body);

  // Map to a list of Players
  List<Player> searchResults = [];

  for (Map player in responseJson['gradedPlayers1']) {
    Player result = new Player.fromJson(player);
    searchResults.add(result);
  }

  for (Map player in responseJson['gradedPlayers2']) {
    Player result = new Player.fromJson(player);
    searchResults.add(result);
  }

  searchResults.sort((a, b) => b.points.compareTo(a.points));

  return searchResults;
}

ListTile buildPlayerRow(Player player) {
  Color color = player.gender == 'Male' ? Colors.red : Colors.blue;

  return new ListTile(
    title: new Text(player.name, style: new TextStyle(fontWeight: FontWeight.w600),),
    subtitle: new Text('${player.grade} | ${player.points}'),
    leading: new Icon(Icons.person),
  );

//  return new Row(
//    children: <Widget>[
//      new Container(
//        margin: const EdgeInsets.only(left: 8.0),
//        child: new Icon(Icons.person, color: color),
//      ),
//      new Container(
//        margin: const EdgeInsets.only(left: 24.0),
//        child: new Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            new Text(
//              player.name,
//              style: new TextStyle(
//                fontSize: 16.0,
//                fontWeight: FontWeight.w600,
//                color: color,
//              ),
//            ),
//            new Text(
//              '${player.grade} | ${player.points}',
//              style: new TextStyle(
//                fontSize: 12.0,
//                fontWeight: FontWeight.w400,
//              ),
//            )
//          ],
//        ),
//      )
//    ],
//  );
}
