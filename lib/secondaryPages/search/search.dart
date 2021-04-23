import 'package:huna/components/profilePicture.dart';

import 'search_model.dart';
import 'package:flutter/material.dart';
import 'package:huna/secondaryPages/tutor_profile/viewTutorProfile.dart';



class SearchPage extends StatefulWidget {
  final String searchValue;

  const SearchPage({Key key, this.searchValue}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  int _rateValue = 1;
  String _majorValue = 'Arts';
  SearchModel _model = new SearchModel();
  Future<List<Map<String, dynamic>>> tutors;
  Widget tutorResuts = Container(width: 0, height: 0);

  

  @override

  void initState()  {
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Search for Tutors'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search for Tutors',
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                  textInputAction: TextInputAction.go,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text('Ratings: ', style: TextStyle(fontSize: 18)),
                        Expanded(
                          child:DropdownButtonFormField(
                            value: _rateValue,
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text('Highest to Lowest'),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text('Lowest to Highest'),
                                value: 2,
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _rateValue = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('Majors: ', style: TextStyle(fontSize: 18)), 
                        Expanded(
                          child: DropdownButtonFormField(
                            value: 'Arts',
                            items: <DropdownMenuItem>[
                              DropdownMenuItem(
                                child: Text('Arts'),
                                value: 'Arts',
                              ),
                              DropdownMenuItem(
                                child: Text('Business and Economics'),
                                value: 'Business and Economics',
                              ),
                              DropdownMenuItem(
                                child: Text('Computer Science'),
                                value: 'Computer Science',
                              ),
                              DropdownMenuItem(
                                child: Text('Engineering'),
                                value: 'Engineering',
                              ),
                              DropdownMenuItem(
                                child: Text('Health, Sciences and Medicine.'),
                                value: 'Health, Sciences and Medicine.',
                              ),
                              DropdownMenuItem(
                                child: Text('History'),
                                value: 'History',
                              ),
                              DropdownMenuItem(
                                child: Text('Humanities'),
                                value: 'Humanities',
                              ),
                              DropdownMenuItem(
                                child: Text('Languages'),
                                value: 'Languages',
                              ),
                              DropdownMenuItem(
                                child: Text('Literature'),
                                value: 'Literature',
                              ),
                              DropdownMenuItem(
                                child: Text('Mathematics'),
                                value: 'Mathematics',
                              ),
                              DropdownMenuItem(
                                child: Text('Music'),
                                value: 'Music',
                              ),
                              DropdownMenuItem(
                                child: Text('Philosophy'),
                                value: 'Philosophy',
                              ),
                              DropdownMenuItem(
                                child: Text('Political Science'),
                                value: 'Political Science',
                              ),
                              DropdownMenuItem(
                                child: Text('Religion'),
                                value: 'Religion',
                              ),
                              DropdownMenuItem(
                                child: Text('Science'),
                                value: 'Science',
                              ),
                              DropdownMenuItem(
                                child: Text('Sports'),
                                value: 'Sports',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _majorValue = value;
                              });
                              print(_majorValue);
                            },
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: ()  async {
                        setState(()  {
                          tutorResuts = Container(
                            height: 480,
                            child: FutureBuilder(
                              future:  _model.getTutors(_majorValue),
                              builder: (context, snapshot) {
                                Widget ret;
                                if(snapshot.connectionState == ConnectionState.done){
                                  if(snapshot.data.length == 0){
                                    ret = Container(
                                      child: Center(
                                        child: Text('No search Results')
                                      )
                                    );
                                  }
                                  if(snapshot.data.length != 0){
                                    ret = ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(15),
                                      itemCount: snapshot == null ? 0 : snapshot.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                          
                                            return new Card(
                                              child: ListTile(
                                                leading: FutureBuilder(
                                                  future: _model.getPicture(snapshot.data[index]['uid']),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                                    Widget ret;
                                                    if(snapshot.connectionState == ConnectionState.waiting){
                                                      ret = Container(child: CircularProgressIndicator());
                                                    }
                                                    if(snapshot.connectionState == ConnectionState.done){
                                                      ret = CircleAvatar(
                                                        child: ProfilePicture(url: snapshot.data)
                                                      );
                                                    }

                                                    return ret;
                                                  }
                                                ),
                                                title: Text('${snapshot.data[index]['firstName']} ${snapshot.data[index]['lastName']}'),
                                                subtitle: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(Icons.star,
                                                        size: 12.0, color: Colors.amber.shade400),
                                                    Icon(Icons.star,
                                                        size: 12.0, color: Colors.amber.shade400),
                                                    Icon(Icons.star,
                                                        size: 12.0, color: Colors.amber.shade400),
                                                    Icon(Icons.star,
                                                        size: 12.0, color: Colors.amber.shade400),
                                                    Icon(Icons.star, size: 12.0),
                                                  ],
                                                ),
                                                trailing: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red.shade800,
                                                ),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => TutorProfilePage(tutorData: snapshot.data[index])),
                                                  );
                                                },
                                              ),
                                            );
                                        },
                                      );
                                  }
                                }else{
                                  ret = Container(
                                    child: Center(
                                      child: CircularProgressIndicator()
                                    )
                                  );
                                }
                                return ret;
                              }
                              
                            ),
                          );
                        });
                      }
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),

              tutorResuts,
              
            ],
          ),
        ),
      ),
    );
  }
}
