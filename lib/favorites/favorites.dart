import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/components/profilePicture.dart';
import 'package:huna/drawer/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/secondaryPages/tutor_profile/viewTutorProfile.dart';
import 'favorites_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  var json, jsonDelete;
  bool isLoading = false;
  bool retVal = false;
  FavoritesModel _model = new FavoritesModel();
  SharedPreferences sp;
  String uid;

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
    });
    print(uid);
  }

  @override
  void initState() {
    super.initState();
    initAwait();
  }

  // Alert Dialog: Remove Tutor from Favorites
  Future<void> removeTutor(String fname, String lname, String tutor_id) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remove Favorite Tutor'),
            content: Text('Are you sure you want to remove ${fname} ${lname}?'),
            elevation: 24.0,
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No", style: TextStyle(color: Colors.cyan)),
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    retVal = await _model.removeFavorite(tutor_id, uid);
                    if (retVal == true) {
                      Fluttertoast.showToast(
                          msg: "Tutor was removied from favorites.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } catch (e) {
                    print(e.toString());
                  }
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Tutors'),
        ),
        drawer: SideDrawer(),
        body: FutureBuilder(
          future: _model.getFavorites(uid),
          builder: (context, snapshot) {
            Widget retWidget;
            if(snapshot.connectionState == ConnectionState.done) {
              print(snapshot.data.length.toString());
              if(snapshot.data.length == 0) {
                retWidget = Center(
                  child: Container(
                    height: 0,
                    width: 0,
                ));
              }
              if(snapshot.data.length !=0 ) {
                retWidget = ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      
                      onTap: () {
                        print(snapshot.data[index]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TutorProfilePage(
                                  tutorData: snapshot.data[index])),
                        );
                      },
                      child: new Card(
                        child: ListTile(
                          leading: FutureBuilder(
                              future: _model.getPicture(
                                  snapshot.data[index]['uid']),
                              builder:
                                  (BuildContext context, AsyncSnapshot snapshot) {
                                Widget ret;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  ret = Container(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  ret = ClipOval(
                                      child: SizedBox(child: ProfilePicture(url: snapshot.data, width: 45, height: 45)));
                                }

                                return ret;
                              }),
                          title: Text(
                              '${snapshot.data[index]['firstName']} ${snapshot.data[index]['lastName']}'),
                          // subtitle: Text(
                          //   '${json[index]['username']}',
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          trailing: IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                removeTutor(
                                    snapshot.data[index]['firstName'],
                                    snapshot.data[index]['lastName'],
                                    snapshot.data[index]['uid']);
                              }),
                        ),
                      ),
                    );
                  },
                );
              }
            } else{
              retWidget = Container(
                child: Center(child: CircularProgressIndicator())
              );
            }
            return retWidget;
          },
        ));
  }
}
