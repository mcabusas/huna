import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huna/modalPages/messages_chatNewBooking.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';
import 'package:http/http.dart' as http;
import 'package:huna/login.dart';


var data;
var jsonData;
Widget buttonRet;

class ChatPage extends StatefulWidget {
  final tutorData, page;

  ChatPage({Key key, this.tutorData, this.page});
  @override
  _ChatState createState() => _ChatState();
  
}

class _ChatState extends State<ChatPage> {


  bool isLoading = false;

  TextEditingController messageController = new TextEditingController();

  insertMessage() async{
    data = {
      'id_from': u.id,
      'userid_to': widget.tutorData['user_id'],
      'message': messageController.text,
      //'time': DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
    };

   final response =  await http.post("https://hunacapstone.com/database_files/chat.php", body: data);

    if(response.statusCode == 200){

      print(jsonDecode(response.body));
    } 
  }

  void initState(){
    super.initState();
    print(widget.tutorData['user_id']);
    if(widget.page == 0){
      buttonRet = IconButton(
              icon: Icon(Icons.date_range, color: Colors.cyan),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new NewBooking(tutorInfo: widget.tutorData)),
                );
              });
    }else{
      buttonRet = Container();
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('${widget.tutorData['user_firstName']} ${widget.tutorData['user_lastName']}'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
            buttonRet,
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Container(width: 0, height: 0),
            ChatMessagesWidget(userID :widget.tutorData['user_id'], page: widget.page),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      hintText: 'Message',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send, 
                          color: Colors.deepPurple, 
                          size: 45,
                        ),
                        onPressed: (){
                          if(messageController.text != ""){
                            insertMessage();
                            messageController.clear();

                          }
                        }
                      ),
                    ),  
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessagesWidget extends StatefulWidget {

  final userID, page;

  ChatMessagesWidget({Key key, this.userID, this.page});
  @override
  _ChatMessagesWidgetState createState() => _ChatMessagesWidgetState();
}

class _ChatMessagesWidgetState extends State<ChatMessagesWidget> {

  bool isLoading = false;


 Future getMessages() async {
    final response = await http.get(
      Uri.encodeFull("https://hunacapstone.com/database_files/getMessages.php?id=${u.id}&toId=${widget.userID}"),
      headers: {
        "Accept": 'application/json',
      }
    );
    if(response.statusCode == 200){
      if(!mounted) return;
      setState(() {
        isLoading = true;
        data = jsonDecode(response.body);
      });
      
      print(isLoading);
      print(data['message'][0]);
      print(data['message'][1]);
    }
  }

  Widget bubble, retWidget;
  

  void initState(){
    super.initState();
    //Timer.periodic(new Duration(seconds: 3), (timer) {
      getMessages();
    //});
  }

  Widget build(BuildContext context) {
    if(isLoading == true){
      if(data == null){
        retWidget = Container(
          child: Center(
            child: Text(
              'No Messages.'
            )
          )
        );
      }else if(data != null){
        print("yes");
        retWidget =  new Container(
          child: Expanded(
            child: ListView.builder(
              itemCount: data['message'] == null ? 0 : data['message'].length,
              padding: EdgeInsets.all(15),
              itemBuilder: (BuildContext context, int index){
                if(data['message'][index]['from'] == u.id){
                  bubble = ChatBubble(
                    message: data['message'][index]['content'], 
                    messageSide: Alignment.centerRight,
                    textSide: TextAlign.end, 
                    bubbleColor: Colors.deepPurple,
                    textColor: Colors.white,
              //  time: data[index]['chat_dateTime'],
                );
              }else if(data['message'][index]['to'] == widget.userID || data['message'][index]['from'] == widget.userID){
                bubble =  ChatBubble(
                  message: data['message'][index]['content'], 
                  messageSide: Alignment.centerLeft, 
                  textSide: TextAlign.start, 
                  bubbleColor: Colors.white,
                  textColor: Colors.black,
                  //time: data[index]['chat_dateTime'],
                );
              }
                return bubble;
              },
            ),
          ),
        );
      }
    }else{
      //retWidget =  Container(width: 0, height: 0);
      retWidget =  new Center(child:CircularProgressIndicator());
    }
    return  retWidget;
  }
}

class ChatBubble extends StatelessWidget {
  final TextAlign textSide;
  final Alignment messageSide;
  final String message; /*time*/
  final Color bubbleColor, textColor;


  ChatBubble({this.textSide, this.messageSide, this.message, this.bubbleColor, this.textColor, /*this.time*/});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Bubble(
            alignment: messageSide,
            margin: BubbleEdges.only(top: 20),
            padding: BubbleEdges.all(15),
            nip: BubbleNip.rightBottom,
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
            color: bubbleColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 15),
            
          ),

        ],
      )
    );
  }
}
