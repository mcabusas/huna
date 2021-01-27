import 'package:flutter/material.dart';
import 'package:huna/profile/myProfileSettings.dart';
import 'package:huna/drawer/drawer.dart';
import 'myProfile_model.dart';


int _selectedIndex = 0;
final tabs = [StudentProfileWidget(), TutorProfileWidget()];
final children = <Widget>[];
var data;
String page;



class MyProfile extends StatefulWidget {
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  MyProfileModel profile = new MyProfileModel();

  Future<Map<String,dynamic>> initAwait() async {
    return profile.myProfileData();
  }
  // Widget bottomNavBar(){
  //   if(u.tutorID == null){
  //     return null;
  //   }else{
  //     return BottomAppBar(
  //       shape: CircularNotchedRectangle(),
  //       notchMargin: 4,
  //       clipBehavior: Clip.antiAlias,
  //       child: BottomNavigationBar(
  //         currentIndex: _selectedIndex,
  //         items: [
  //           BottomNavigationBarItem(
  //             icon: Icon(Icons.school),
  //             title: Text('Student'),
  //           ),
  //           BottomNavigationBarItem(
  //             icon: Icon(Icons.local_cafe),
  //             title: Text('Tutor'),
  //           ),
  //         ],
  //         onTap: (index) {
  //           setState(() {
  //             _selectedIndex = index;
  //             if(index == 0){
  //               page = 'student';
  //             }else if(index == 1){
  //               page = 'tutor';
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   }
  // }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initAwait(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
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
            drawer:SideDrawer(),
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
                            '${snapshot.data['firstName']} ${snapshot.data['lastName']}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Center(
                          child: Text(
                            snapshot.data['username'],
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
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
                              '${snapshot.data['city']}, ${snapshot.data['country']}',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
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
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.star, size: 20),
                                    Icon(Icons.star, size: 20),
                                    Icon(Icons.star, size: 20),
                                    Icon(Icons.star, size: 20),
                                    Icon(Icons.star, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Reviews and Average Star Ratings
                        tabs[_selectedIndex],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //bottomNavigationBar: bottomNavBar(),
            
          );
        }else{
          return Scaffold(
            body: Container(
              child: Center(
                child: CircularProgressIndicator()
              )
            )
          );
        }
      }
    );
  }
}

class TutorProfileWidget extends StatefulWidget {
  @override
  _TutorProfileWidgetState createState() => _TutorProfileWidgetState();
}

class _TutorProfileWidgetState extends State<TutorProfileWidget> {
    bool isLoading = false;


    // getData() async{
    //   print(page);
    //   final response = await http.get(
    //     Uri.encodeFull("https://hunacapstone.com/database_files/profile.php?id=${u.tutorID}&page=$page"),
    //     headers: {
    //       "Accept": 'application/json',
    //     }
    //   );
    //   if(response.statusCode == 200){
    //     if(!mounted) return;
    //     setState(() {
    //       isLoading = true;
    //       data = jsonDecode(response.body);
    //     });
    //   }
    //   print(data);
    // }

    // void initState()  {
    //   super.initState();
    //   this.getData();
    // }

  @override
  Widget build(BuildContext context) {
    if(isLoading == true){
      return Container(
        child: Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              if(data == null){
                return new Container();
              }else{
                return new Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    subtitle: Text(
                      data[index]['content']
                    ),
                    isThreeLine: true,
                  ),
                );

              }
            },
          ),
        ),
      );
    }else{
      return Center(child:CircularProgressIndicator());
    }
  }
}

class StudentProfileWidget extends StatefulWidget {
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


  // @override
  
  // void initState()  {
  //   super.initState();
  //   this.getData();
  // }
  
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(20),
                subtitle: Text(
                  data[index],
                            //'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. ',
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),

    );
    
      
  }
  
 
}

