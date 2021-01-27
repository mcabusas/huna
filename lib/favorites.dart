import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:http/http.dart' as http;
import 'login/login.dart';
import 'package:fluttertoast/fluttertoast.dart';



class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {

  var json, jsonDelete;
  bool isLoading = false;

  // Future getFavorites() async{
  //   final response = await http.get(
  //     Uri.encodeFull("https://hunacapstone.com/database_files/favorite.php?id=${u.id}"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       json = jsonDecode(response.body);
  //       isLoading = true;
  //     });
  //   }
  // }

  // Future deleteFavorite(var tid) async{
  //   var body = {
  //     'id': u.id,
  //     'tid': tid
  //   };
  //   final response = await http.post('https://hunacapstone.com/database_files/deleteFavorite.php', body: body);
  //   if(response.statusCode == 200){
  //     if(!mounted) return;
  //     setState(() {
  //        jsonDelete = jsonDecode(response.body);
  //     });
  //     Fluttertoast.showToast(
  //       msg: "Tutor was removed from your favorites.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIos: 1,
  //       backgroundColor: Colors.blue,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

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
                  //deleteFavorite(tid);
                  Navigator.pop(context);
                  setState(() {
                    isLoading = false;
                    //getFavorites();
                  });
                },
                child: Text("Yes", style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          );
        });
  }

  @override
  // void initState() {
  //   super.initState();
  //   this.getFavorites();
    
  // }
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
            itemCount: json == 'false' ? 0 : json.length,
            itemBuilder: (BuildContext context, int index) {
              if(json == 'false'){
                return new Container(
                  child: Center(
                    child: Text("You have no favorite tutors added yet.")
                  ),
                );
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
