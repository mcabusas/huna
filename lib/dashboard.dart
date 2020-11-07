import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:huna/login.dart';
import 'package:huna/secondaryPages/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:huna/secondaryPages/viewTutorProfile.dart';
import 'package:huna/modalPages/drawer.dart';



class DashboardPage extends StatefulWidget {
  final u;
  const DashboardPage({Key key, this.u});
  
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  var data, tutorID, tutorInfo;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.getTutors();
    
  }

  Future getTutors() async{

    final response = await http.get(
      Uri.encodeFull("http://192.168.1.7/huna/database_files/classes/controllers/dashboardcontroller.class.php"));
    if(response.statusCode == 200){
      setState(() {
        isLoading = true;
        data = jsonDecode(response.body);
      });
    }else{
      print(response.statusCode);
    }

    for(int i = 0; i < data.length; i++){
      print(data[i].toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: SideDrawer(),
      //COMMENT
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            //body should have topLeft and topRight Radius
            floating: true,
            pinned: true, //Pins the appbar on top
            snap: false,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Dashboard'),
              background: Image.asset(
                'assets/images/mountains.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: <Widget>[
                  // Search Bar
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search for Tutors',
                            ),
                            onSubmitted: (value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage(searchValue: value)),
                              );
                            },
                            textInputAction: TextInputAction.go,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Featured Tutors Label
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Text(
                            'Featured Tutors',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),

                  isLoading ?
                  // Featured Tutors List
                  Container(
                    height: 225,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            print(data[index]['user_id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TutorProfilePage(tutorInfo: data[index])),
                            );
                          },
                            child: Container(
                            width: 130,
                            child: Card(
                              // color: Colors.black,
                              child: Wrap(
                                children: <Widget>[
                                  Image.asset('assets/images/tutor.jpg'),
                                  ListTile(
                                    title: Text('${data[index]['user_firstName']} ${data[index]['user_lastName']}'),
                                    subtitle: Text(data[index]['username']),
                                  ),
                                  Visibility(
                                    child: Text(data[index]['tutor_id']),
                                    visible: false, 
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ) :
                  CircularProgressIndicator(),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
