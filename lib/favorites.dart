import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huna/modalPages/drawer.dart';
import 'package:http/http.dart' as http;
import 'login.dart';



class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {

  bool isLoading = false;
  var json;

  Future getFavorites() async{
    final response = await http.get(
      Uri.encodeFull("https://hunacapstone.com/database_files/favorite.php?id=${u.id}"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      setState(() {
        json = jsonDecode(response.body);
        isLoading = true;
      });
    }

    print(json);
    print(isLoading.toString());
  }

  Future deleteFavorite(var tid) async{
    var body = {
      'id': u.id,
      'tid': tid
    };
    final response = await http.post('https://hunacapstone.com/database_files/deleteFavorite.php', body: body);
    if(response.statusCode == 200){
      if(!mounted) return;
      setState(() {
         json = jsonDecode(response.body);
      });
      print(json);
    }
  }

  // Alert Dialog: Remove Tutor from Favorites
  Future<void> removeTutor(String fName, String lName, var tid) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remove Favorite Tutor'),
            content: Text('Are you sure you want to remove $fName $lName?'),
            elevation: 24.0,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No", style: TextStyle(color: Colors.cyan)),
              ),
              FlatButton(
                onPressed: () {
                  deleteFavorite(tid);
                },
                child: Text("Yes", style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.getFavorites();
    
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Tutors'),
      ),
      drawer: SideDrawer(),
      body: Container(
        child: isLoading ?
           ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            itemCount: json == null ? 0 : json.length,
            itemBuilder: (BuildContext context, int index) {
              if(json == null){
                return new Container();
              }else{
                return new Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                    ),
                    title: Text('${json[index]['user_firstName']} ${json[index]['user_lastName']}'),
                    subtitle: Text(
                      '${json[index]['username']}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red), 
                      onPressed: (){
                        removeTutor(json[index]['user_firstName'], json[index]['user_lastName'], json[index]['tutor_id']);
                      } 
                    ),
                  ),
                );
              }
            },
          )
          :
          Center(child: CircularProgressIndicator())
      )
    );
  }
}
