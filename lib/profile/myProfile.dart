import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huna/profile/myProfileSettings.dart';
import 'package:huna/drawer/drawer.dart';
import 'myProfile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';

int _selectedIndex = 0;
enum WidgetMaker { student, tutor }
//final tabs = [StudentProfileWidget(), TutorProfileWidget()];
final children = <Widget>[];
var data;
MyProfileModel _model = new MyProfileModel();
double ratings;

class MyProfile extends StatefulWidget {
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  SharedPreferences sp;
  String uid, tid;
  AuthServices _auth = new AuthServices();
  WidgetMaker selectedWidget = WidgetMaker.student;

  Map<String, dynamic> userData = {};

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getString('uid');
      tid = sp.getString('tid');
      print(sp.getString('tid') + 'this is tid');
      userData = (_auth.userProfile(uid));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAwait();
  }

  Widget getScreen() {
    switch (selectedWidget) {
      case WidgetMaker.student:
        return StudentProfileWidget(id: uid, flag: 0);

      case WidgetMaker.tutor:
        return TutorProfileWidget(id: uid, flag: 1, tid: tid);
    }

    return getScreen();
  }

  Widget bottomNavBar() {
    if (tid == null) {
      return null;
    } else {
      return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('Student'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_cafe),
              title: Text('Tutor'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 0) {
                setState(() {
                  selectedWidget = WidgetMaker.student;
                });
              } else if (index == 1) {
                setState(() {
                  selectedWidget = WidgetMaker.tutor;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfileSettings()),
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(height: 20),
                  // Profile Text
                  Center(
                    child: Text(
                      '${sp.getString('firstName')} ${sp.getString('lastName')}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  // Center(
                  //   child: Text(
                  //     snapshot.data['username'],
                  //     style: TextStyle(color: Colors.white70),
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  // Location
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 15,
                        ),
                        Text(
                          '${sp.getString('city')}, ${sp.getString('country')}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  getScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}

class TutorProfileWidget extends StatefulWidget {
  final id;
  final flag;
  final tid;
  TutorProfileWidget({this.id, this.flag, this.tid});
  @override
  _TutorProfileWidgetState createState() => _TutorProfileWidgetState();
}

class _TutorProfileWidgetState extends State<TutorProfileWidget> {
  
  Future<List<Map<String, dynamic>>> initAwait() async {
    ratings = await _model.getRating(widget.id, 1);
    print(ratings.toString());
    return await _model.getTutorReviews(widget.id);
  }

  @override

  void initState()  {
    super.initState();
    initAwait();
    print(widget.flag);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: initAwait(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.data.length == 0){
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Text('You have no reviews.'),
                ),
              );
            }else{
              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, top: 30.0, right: 25.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Reviews Label
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Average Star Ratings
                        IconTheme(
                          data: IconThemeData(
                            color: Colors.amber,
                            size: 20
                          ),
                          child: StarDisplay(value: ratings)
                        )
                      ],
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data.length == 0) {
                        return new Container();
                      } else {
                        return new Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(20),
                            title: IconTheme(
                              data: IconThemeData(
                                color: Colors.amber,
                                size: 20
                              ),
                              child: StarDisplay(value: snapshot.data[index]['tutor_rating'].toDouble(),),
                            ),
                            subtitle: Text(snapshot.data[index]['content']),
                            isThreeLine: true,
                          ),
                        );
                      }
                    },
                  )

                ],
              );
            }
          }else {
            return Container(
              child: Center(child: CircularProgressIndicator())
            );
          }
        },
      )
    );
  }
}

class StudentProfileWidget extends StatefulWidget {
  final id;
  final flag;
  StudentProfileWidget({this.id, this.flag});
  @override
  _StudentProfileWidgetState createState() => _StudentProfileWidgetState();
}

class _StudentProfileWidgetState extends State<StudentProfileWidget> {
  // getData() async{

  //   print(page);
  //   final response = await http.get(
  //     Uri.encodeFull("https://hunacapstone.com//database_files/profile.php?id=${u.id}&page=$page"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       data = jsonDecode(response.body);
  //     });
  //   }
  // }

  Future<List<Map<String, dynamic>>> initAwait() async {
    ratings = await _model.getRating(widget.id, 1);
    print(ratings.toString());
    return await _model.getStudentReviews(widget.id);
  }

  @override

  void initState()  {
    super.initState();
    initAwait();
  }

  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: initAwait(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.data.length == 0){
              return Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Text('You have no reviews.'),
                ),
              );
            }else{
              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, top: 30.0, right: 25.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Reviews Label
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Average Star Ratings
                        IconTheme(
                          data: IconThemeData(
                            color: Colors.amber,
                            size: 20
                          ),
                          child: StarDisplay(value: ratings)
                        )
                      ],
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data.length == 0) {
                        return new Container();
                      } else {
                        return new Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(20),
                            title: IconTheme(
                              data: IconThemeData(
                                color: Colors.amber,
                                size: 20
                              ),
                              child: StarDisplay(value: snapshot.data[index]['student_rating'].toDouble(),),
                            ),
                            subtitle: Text(snapshot.data[index]['content']),
                            isThreeLine: true,
                          ),
                        );
                      }
                    },
                  )

                ],
              );
            }
          }else {
            return Container(
              child: Center(child: CircularProgressIndicator())
            );
          }
        },
      )
    );
  }
}

class StarDisplay extends StatelessWidget {
  final double value;
  StarDisplay({this.value = 0.0})
    :assert(value != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
         return Icon(
          index < value ? Icons.star : Icons.star_border
        );
      })
    );
  }
}
