import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:huna/profile/myProfileSettings.dart';
import 'myProfile_model.dart';



class TagsPage extends StatefulWidget {
  final tid;
  final majors;
  final languages;
  final topics;
  TagsPage({this.tid, this.topics, this.languages, this.majors});
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<TagsPage> {



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

  List<String> majorTiles = [];

  // Languages
  List<String> _languageTags = [];
  String _language;

  // Topic
  List<String> _topicsTags = [];
  String _topic;
  MyProfileModel _model = new MyProfileModel();

  final TextEditingController _languageController = new TextEditingController();
  final TextEditingController _topicController = new TextEditingController();

  void widgetToList() {
    for(String language in widget.languages){
      _languageTags.add(language);
    }
    for(String topic in widget.topics) {
      _topicsTags.add(topic);
    }
    for(String major in widget.majors){
      majorTiles.add(major);
    }
  }

  void initState(){
    super.initState();
    widgetToList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics, Skills and Languages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(
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
                value: majorTiles.contains('Arts'),
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
                value: majorTiles.contains('Business and Economics'),
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
                value: majorTiles.contains('Computer Science'),
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
                value:majorTiles.contains('Engineering'),
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
                value: majorTiles.contains('Health and Sciences & Medicine'),
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
                value: majorTiles.contains('History'),
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
                value: majorTiles.contains('Humanities'),
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
                value: majorTiles.contains('Languages'),
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
                value: majorTiles.contains('Literature'),
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
                value: majorTiles.contains('Mathematics'),
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
                value: majorTiles.contains('Music'),
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
                value: majorTiles.contains('Philosophy'),
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
                value: majorTiles.contains('Political Science'),
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
                value: majorTiles.contains('Religion'),
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
                value: majorTiles.contains('Science'),
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
                value: majorTiles.contains('Science'),
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
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton.icon(
                    onPressed: () async {
                    if(majorTiles.isNotEmpty) {
                      bool catcher = await _model.updateMajorTags(widget.tid, majorTiles);
                      if(catcher) {
                        Fluttertoast.showToast(
                          msg: "Majors updated successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      }
                    }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    color: Colors.grey.shade900,
                    textColor: Colors.white,
                  ),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton.icon(
                    onPressed: () async {
                    // updateTags();
                    if(_languageTags.isNotEmpty) {
                      bool catcher = await _model.updateLanguageTags(widget.tid, _languageTags);
                      if(catcher) {
                        Fluttertoast.showToast(
                          msg: "Languages updated successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      }
                    }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    color: Colors.grey.shade900,
                    textColor: Colors.white,
                  ),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton.icon(
                    onPressed: () async {
                    // updateTags();
                    if(_topicsTags.isNotEmpty) {
                      bool catcher = await _model.updateTopicsTags(widget.tid, _topicsTags);
                      if(catcher) {
                        Fluttertoast.showToast(
                          msg: "Topics updated successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      }
                    }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                    color: Colors.grey.shade900,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
