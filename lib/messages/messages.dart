import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/historyPages/bookingHistory.dart';
import 'package:huna/login/login.dart';
import 'package:huna/modalPages/chat/messages_chat.dart';
import 'package:huna/drawer/drawer.dart';
import 'message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

var jsonData;

int _selectedIndex = 0;
enum WidgetMaker { student, tutor }
String prefId, tutorId;
MessagesModel _model = new MessagesModel();
SharedPreferences sp; 




class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  WidgetMaker selectedWidget = WidgetMaker.student;
  

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      prefId = sp.getString('uid');
      tutorId = sp.getString('tid');
    });
  }

  Widget getScreen(){
    switch(selectedWidget){
      case WidgetMaker.student:
        return StudentMessages(uid: prefId);
        
      case WidgetMaker.tutor:
        return TutorMessages(uid: prefId);
    }
    return getScreen();
  }

  @override
  void initState() {
    super.initState();
    initAwait();
    _selectedIndex = 0;
  }
  
  Widget bottomNavBar(){
    if(tutorId == ''){
      return null;
    }
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
              if(index == 0){
                 setState(() {
                   selectedWidget = WidgetMaker.student;
                 });
              }else if(index == 1){
                 setState(() {
                   selectedWidget = WidgetMaker.tutor;
                 });
              }
            });
          },
        ),
      );
    
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      drawer: SideDrawer(),
      body: getScreen(),
      bottomNavigationBar: bottomNavBar(),
    );
  }
}




class TutorMessages extends StatefulWidget {
  final uid;
  TutorMessages({this.uid});

  @override
  _TutorMessagesState createState() => _TutorMessagesState();
}

class _TutorMessagesState extends State<TutorMessages> {

  Future<List<Map<String, dynamic>>> initAwait() async{
    
    //return await _model.getStudentChatRooms();
    return await _model.getTutorChatRooms(widget.uid);
  }
  @override
  void initState(){
    super.initState();
    print('in tutor' + sp.getString('uid'));
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: initAwait(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data.length == 0){
            return Container(
              height: 100,
              width: 100,
              child: Center(
                child: Text('YOU NO NEW MESSAGES')
              )
            );
          }else{
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15),
              itemCount: snapshot == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                      ),
                      title: Text('${snapshot.data[index]['firstName']} ${snapshot.data[index]['lastName']}'),
                      // subtitle: Text(
                      //   '${jsonData[index]['username']}',
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      onTap: () {
                        // print(jsonData[index]['chat_id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage(tutorData: snapshot.data[index], chatRoomId: snapshot.data[index]['chatRoomId'], page: 1)),
                        );
                      },
                    ),
                  );
              },
            );
          }
        }else{
          return Container(
            child: Center(child: CircularProgressIndicator())
          );
        }
      }
    );
      
    
    
  }
}



class StudentMessages extends StatefulWidget {
  final uid;
  StudentMessages({this.uid});
  @override
  _StudentMessagesState createState() => _StudentMessagesState();
}

class _StudentMessagesState extends State<StudentMessages> {

  Future<List<Map<String, dynamic>>> initAwait() async{
    
    return await _model.getStudentChatRooms(widget.uid);
  }
  
  void initState(){
    super.initState();
    print('in student' + widget.uid);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: initAwait(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.data.length == 0){
            return Container(
              height: 100,
              width: 100,
              child: Center(
                child: Text('YOU NO NEW MESSAGES')
              )
            );
          }else{
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(15),
              itemCount: snapshot == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                      ),
                      title: Text('${snapshot.data[index]['firstName']} ${snapshot.data[index]['lastName']}'),
                      // subtitle: Text(
                      //   '${jsonData[index]['username']}',
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      onTap: () {
                        // print(jsonData[index]['chat_id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage(tutorData: snapshot.data[index], chatRoomId: snapshot.data[index]['chatRoomId'], page: 0)),
                        );
                      },
                    ),
                  );
              },
            );
          }
        }else{
          return Container(
            child: Center(child: CircularProgressIndicator())
          );
        }
      }
    );
      
    
    
  }
}

