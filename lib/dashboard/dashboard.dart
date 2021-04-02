import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:huna/login/login.dart';
import 'package:huna/secondaryPages/search.dart';
import 'package:huna/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:huna/secondaryPages/tutor_profile/viewTutorProfile.dart';
import 'package:huna/drawer/drawer.dart';
import 'dashboard_model.dart';
import '../components/profilePicture.dart';



class DashboardPage extends StatefulWidget {
  final u;
  const DashboardPage({Key key, this.u});
  
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  var data, tutorID, tutorInfo;

  bool isLoading = false;
  DashboardModel dashboardModel = new DashboardModel();
  AuthServices _s = new AuthServices();
  List<Map<String, dynamic>> retVal;
  SharedPreferences sp;

  // Future List<Map<String, dynamic>>> initAwait() async {
  //   Future List<<Map<String, dynamic>>> retVal = dashboardModel.getTutors();
  //   return retVal;
  // }

  // Future<List<Map<String, dynamic>>> initAwait() async{
    
  //   return await dashboardModel.getTutors();
  // }

 Stream tutorsStream;

 Future initAwait() async {
   SharedPreferences sp = await SharedPreferences.getInstance();
   print(sp.getString('tid'));
 }
  

  @override
  void initState() {
    super.initState();
    tutorsStream = dashboardModel.getTutors();
    initAwait();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  // Featured Tutors List
                  StreamBuilder(
                    stream: tutorsStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      Widget retVal;
                      if(snapshot.connectionState == ConnectionState.waiting){
                        retVal = Center(child: CircularProgressIndicator());
                      }else if(snapshot.connectionState == ConnectionState.active){
                        retVal = Container(
                          height: 225,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(15),
                            itemCount: snapshot == null ? 0 : snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: (){
                                   print(snapshot.data.docs[index]['majors']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TutorProfilePage(tutorData: snapshot.data.docs[index])),
                                  );
                                },
                                  child: Container(
                                  width: 130,
                                  child: Card(
                                    // color: Colors.black,
                                    child: Wrap(
                                      children: <Widget>[
                                        FutureBuilder(
                                          future: dashboardModel.getPicture(snapshot.data.docs[index]['uid']),
                                          builder: (BuildContext context, AsyncSnapshot snap) {
                                            Widget picture;
                                            if (snap.connectionState == ConnectionState.waiting) {
                                              picture = Container(child: CircularProgressIndicator());
                                            }
                                            if(snap.connectionState == ConnectionState.done) {
                                              picture = ProfilePicture(url: snap.data, width: 200, height: 100);
                                            }
                                            
                                            return picture;
                                          }
                                        ),
                                        ListTile(
                                          title: Text('${snapshot.data.docs[index]['firstName']} ${snapshot.data.docs[index]['lastName']}'),
                                          //subtitle: Text(snapshot.data[index]['username']),
                                        ),
                                        // Visibility(
                                        //   child: Text(data[index]['tutor_id']),
                                        //   visible: false, 
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        );
                      }
                      return retVal;
                    }
                      
                    
                  )
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
