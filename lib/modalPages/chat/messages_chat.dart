import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/modalPages/messages_chatNewBooking.dart';
import 'package:bubble/bubble.dart';
import 'package:huna/services/auth_services.dart';
import 'messages_chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
Widget buttonRet;

class ChatPage extends StatefulWidget {
  final tutorData, chatRoomId;

  ChatPage({Key key, this.tutorData, this.chatRoomId});
  @override
  _ChatState createState() => _ChatState();
  
}

class _ChatState extends State<ChatPage> {


  bool isLoading = false;

  TextEditingController messageController = new TextEditingController();
  MessagesChatModel _model = new MessagesChatModel();
  Widget bubble;
  SharedPreferences sp;

  Stream conversationMessages;

  Future<void> initAwait() async {
    sp = await SharedPreferences.getInstance();
  }

  @override
  void initState(){
    super.initState();
    initAwait();
    conversationMessages = _model.getConversationMessages(widget.chatRoomId);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('${widget.tutorData['firstName']} ${widget.tutorData['lastName']}'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.date_range, color: Colors.cyan),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new NewBooking(tutorInfo: widget.tutorData)),
                );
              }),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Container(width: 0, height: 0),
            StreamBuilder(
              stream: conversationMessages,
              builder: (context, snapshot){
                if(snapshot.data == null){
                  return Center(child:Text('Start Chatting...'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot message = snapshot.data.docs[index];
                    if(message['sentBy'] == sp.getString('uid')){
                      bubble = ChatBubble(
                        message: message['message'],
                        messageSide: Alignment.centerRight,
                        textSide: TextAlign.end,
                        bubbleColor: Colors.deepPurple,
                        textColor: Colors.white,
                      );
                    }else {
                      bubble = ChatBubble(
                        message: message['message'],
                        messageSide: Alignment.centerLeft,
                        textSide: TextAlign.start,
                        bubbleColor: Colors.white,
                        textColor: Colors.black,
                      );
                    }
                    return bubble;
                  }
                  
                );
              },
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
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
                          if(messageController.text.isNotEmpty){
                            _model.insertMessage(widget.chatRoomId, messageController.text);
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
