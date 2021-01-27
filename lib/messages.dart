import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/login/login.dart';
import 'package:huna/modalPages/messages_chat.dart';
import 'package:http/http.dart' as http;
import 'package:huna/drawer/drawer.dart';

var jsonData;

int _selectedIndex = 0;
final tabs = [StudentMessages(), TutorMessages()];
var page;
bool isLoading = false;




class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: tabs[_selectedIndex]
    );
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  
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
  //               page = 0;
  //             }else if(index == 1){
  //               page = 1;
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   }
  // }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      drawer: SideDrawer(),
      body: MainWidget(),
      //bottomNavigationBar: bottomNavBar(),
    );
  }
}

class TutorMessages extends StatefulWidget {
  @override
  _TutorMessagesState createState() => _TutorMessagesState();
}

class _TutorMessagesState extends State<TutorMessages> {

  // getChats() async{
  //    final response = await http.get(
  //     Uri.encodeFull("http://www.hunacapstone.com/api/classes/controllers/getChatsController.class.php?id=${u.id}&flag=1"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       jsonData = jsonDecode(response.body);
  //       isLoading = true;
  //     });
  //      print("flutter flag: " + jsonData.toString());
  //   }

  // }
  
  // void initState(){
  //   super.initState();
  //   getChats();
  // }

  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      if(jsonData == null){
        return new Container(
          child: Center(
            child: Text('you no new messages! _tutorMode')
          )
        );
      }else if(jsonData != null && jsonData.length > 0){
        return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        itemCount: jsonData == null ? 0 : jsonData.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                ),
                title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                subtitle: Text(
                  '${jsonData[index]['username']}',
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage(tutorData: jsonData[index], page: page)),
                  );
                },
              ),
            );
        },
      );
      }
    }else{
      return Center(child:CircularProgressIndicator());
    }
  }
}



class StudentMessages extends StatefulWidget {
  @override
  _StudentMessagesState createState() => _StudentMessagesState();
}

class _StudentMessagesState extends State<StudentMessages> {


  // getChats() async{
  //    final response = await http.get(
  //     Uri.encodeFull("http://www.hunacapstone.com/api/classes/controllers/getChatsController.class.php?id=${u.id}&flag=0"),
  //     headers: {
  //       "Accept": 'application/json',
  //     }
  //   );
  //   if(response.statusCode == 200){
  //     setState(() {
  //       jsonData = jsonDecode(response.body);
  //       isLoading = true;
  //     });
  //     print("flutter flag: " + jsonData.toString());
  //   }

  // }
  
  // void initState(){
  //   super.initState();
  //   getChats();
  // }

  @override
  Widget build(BuildContext context) {
    if(isLoading == true) {
      if(jsonData == null){
        return new Container(
          child: Center(
            child: Text('You have no new messages!')
          )
        );
      }else if(jsonData != null && jsonData.length > 0){
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          itemCount: jsonData == null ? 0 : jsonData.length,
          itemBuilder: (BuildContext context, int index) {
            if(jsonData == null){
              return new Container();
            }else{
              return new Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/tutor2.jpg'),
                  ),
                  title: Text('${jsonData[index]['user_firstName']} ${jsonData[index]['user_lastName']}'),
                  subtitle: Text(
                    '${jsonData[index]['username']}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    print(jsonData[index]['chat_id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(tutorData: jsonData[index],  page: page)),
                    );
                  },
                ),
              );
            }
          },
        );
      }
    }else{
      return Center(child:CircularProgressIndicator());
    }
    
    
  }
}

