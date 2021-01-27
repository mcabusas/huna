import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huna/profile/myProfileSettings.dart';
import 'package:http/http.dart' as http;
import 'package:huna/login/login.dart';



class TagsPage extends StatefulWidget {
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<TagsPage> {

  void initState(){
    super.initState();
    tutorPage = 2;
    print(tutorPage);
  }


  // Future updateTags() async{
  
  //   var data = {
  //     'majors': majorTiles.toString(),
  //     'lang': _languageTags.toString(),
  //     'topics': _topicsTags.toString(),
  //   };


  //   final response = await http.post("https://hunacapstone.com/database_files/profileSettingsTutor.php?id=${u.tutorID}&pageTutor=$tutorPage", body: data);
  //   if(response.statusCode == 200){
  //     setState(() {
  //       jsonData = jsonDecode(response.body);
  //     });
  //     print(jsonData);
  //   }
    
  // }


  // Checkboxes
  var chk_art;
  var chk_bande;
  var chk_comsci;
  var chk_eng;
  var chk_healthsci;
  var chk_his;
  var chk_humn;
  var chk_lang;
  var chk_polsci;
  var chk_lit;
  var chk_math;
  var chk_mus;
  var chk_philo;
  var chk_reli;
  var chk_sci;
  var chk_sprt;

  List<String> majorTiles = List();

  // Languages
  List<String> _languageTags = List();
  String _language;

  // Topic
  List<String> _topicsTags = List();
  String _topic;

  final TextEditingController _languageController = new TextEditingController();
  final TextEditingController _topicController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics, Skills and Languages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyProfileSettings()),
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                'Major Fields of Study',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              // Checkboxes
              CheckboxListTile(
                title: Text('Arts'),
                value: chk_art == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Arts');
                  }else{
                    majorTiles.remove('Arts');
                  }
                  setState(() {
                    chk_art = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Business and Economics'),
                value: chk_bande == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Business and Economics');
                  }else{
                    majorTiles.remove('Business and Economics');
                  }
                  setState(() {
                    chk_bande = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Computer Science'),
                value: chk_comsci == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Computer Science');
                  }else{
                    majorTiles.remove('Computer Science');
                  }
                  setState(() {
                    chk_comsci = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Engineering'),
                value: chk_eng == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Engineerings');
                  }else{
                    majorTiles.remove('Engineering');
                  }
                  setState(() {
                    chk_eng = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Health and Sciences & Medicine'),
                value: chk_healthsci == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Health and Sciences & Medicine');
                  }else{
                    majorTiles.remove('Health and Sciences & Medicine');
                  }
                  setState(() {
                    chk_healthsci = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('History'),
                value: chk_his == 1,
                onChanged: (bool value) {
                  if(value == true){
                    majorTiles.add('History');
                  }else{
                    majorTiles.remove('History');
                  }
                  setState(() {
                    chk_his = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Humanities'),
                value: chk_humn == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Humanities');
                  }else{
                    majorTiles.remove('Humanities');
                  }
                  setState(() {
                    chk_humn = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Languages'),
                value: chk_lang == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Languages');
                  }else{
                    majorTiles.remove('Languages');
                  }
                  setState(() {
                    chk_lang = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Literature'),
                value: chk_lit == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Literature');
                  }else{
                    majorTiles.remove('Literature');
                  }
                  setState(() {
                    chk_lit = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Mathematics'),
                value: chk_math == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Mathematics');
                  }else{
                    majorTiles.remove('Mathematics');
                  }
                  setState(() {
                    chk_math = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Music'),
                value: chk_mus == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Music');
                  }else{
                    majorTiles.remove('Music');
                  }
                  setState(() {
                    chk_mus = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Philosophy'),
                value: chk_philo == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Philosophy');
                  }else{
                    majorTiles.remove('Philosophy');
                  }
                  setState(() {
                    chk_philo = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Political Science'),
                value: chk_polsci == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Political Science');
                  }else{
                    majorTiles.remove('Political Science');
                  }
                  setState(() {
                    chk_polsci = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Religion'),
                value: chk_reli == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Religion');
                  }else{
                    majorTiles.remove('Religion');
                  }
                  setState(() {
                    chk_reli = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Science'),
                value: chk_sci == 1,
                onChanged: (bool value) {
                   if(value == true){
                    majorTiles.add('Science');
                  }else{
                    majorTiles.remove('Science');
                  }
                  setState(() {
                    chk_sci = value ? 1 : 0;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Sports'),
                value: chk_sprt == 1,
                onChanged: (bool value) {
                  if(value == true){
                    majorTiles.add('Sports');
                  }else{
                    majorTiles.remove('Sports');
                  }
                  setState(() {
                    chk_sprt = value ? 1 : 0;
                  });
                },
              ),
            ],
          ),
          Divider(),

          // Spoken Languages

          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                'Spoken Languages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _languageController,
                  decoration: InputDecoration(
                    hintText: 'Language',
                  ),
                  maxLength: 20,
                  onChanged: (language) {
                    _language = language;
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text("Add Language",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.lightGreen,
                      onPressed: () {
                        setState(() {
                          _languageTags.add(_language);
                          _languageController.clear();
                        });
                      },
                    ),
                  ],
                ),
                ListView(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  children: _languageTags
                      .map(
                        (element) => Chip(
                          label: Text(
                            element,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.cyan,
                          deleteIcon: Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            setState(() {
                              _languageTags.remove(element);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          Divider(),

          // Topics of Expertise

          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Center(
              child: Text(
                'Topics of Expertise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    hintText: 'Topic',
                  ),
                  maxLength: 20,
                  onChanged: (topic) {
                    _topic = topic;
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text("Add Topic",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.lightGreen,
                      onPressed: () {
                        setState(() {
                          _topicsTags.add(_topic);
                          _topicController.clear();
                        });
                      },
                    ),
                  ],
                ),
                ListView(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  children: _topicsTags
                      .map(
                        (element) => Chip(
                          label: Text(
                            element,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.deepPurple.shade300,
                          deleteIcon: Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            setState(() {
                              _topicsTags.remove(element);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: RaisedButton.icon(
              onPressed: () {
               // updateTags();
              },
              icon: Icon(Icons.save),
              label: Text('Save'),
              color: Colors.grey.shade900,
              textColor: Colors.white,
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
