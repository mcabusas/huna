import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/modalPages/newBooking/messages_chatNewBooking.dart';
import 'package:bubble/bubble.dart';
import 'package:huna/services/auth_services.dart';
import 'messages_chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
Widget buttonRet;

class ChatPage extends StatefulWidget {
  final tutorData, chatRoomId, page;

  ChatPage({Key key, this.tutorData, this.chatRoomId, this.page});
  @override
  _ChatState createState() => _ChatState();
  
}

class _ChatState extends State<ChatPage> {


  bool isLoading = false;

  TextEditingController messageController = new TextEditingController();
  MessagesChatModel _model = new MessagesChatModel();
  Widget bubble, bookingWidget;
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
    print(widget.tutorData['firstName']);
    print(widget.tutorData['uid']);
  }

  Widget getButtonWidget(){
    if(widget.page == 0){
      return IconButton(
        icon: Icon(Icons.date_range, color: Colors.cyan),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new NewBooking(tutorInfo: widget.tutorData, chatRoomId: widget.chatRoomId)),
          );
        });
    }else if(widget.page == 1){
      return Container(width: 0, height: 0);
    }
    return getButtonWidget();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('${widget.tutorData['firstName']} ${widget.tutorData['lastName']}'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: 
        <Widget>[
          getButtonWidget()
            // IconButton(
            //   icon: Icon(Icons.date_range, color: Colors.cyan),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => new NewBooking(tutorInfo: widget.tutorData)),
            //     );
            //   }),
        ],
      ),
      body: Stack(
        children: [


          StreamBuilder(
              stream: conversationMessages,
              builder: (context, snapshot){
                if(snapshot.data == null){
                  return Center(child:Text('Start Chatting...'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 80.0),
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index){
                    DocumentSnapshot message = snapshot.data.docs[index];

                    DateTime dtEpoch = DateTime.fromMicrosecondsSinceEpoch(message['timeStamp']);
                    // String dateT = DateFormat('yyyy-MM-dd - hh:mm a').format(dtEpoch);
                    String dateT = DateFormat('MMMM dd, yyyy hh:mm a').format(dtEpoch);

                    if(message['sentBy'] == sp.getString('uid')){
                      bubble = ChatBubble(
                        message: message['message'],
                        messageSide: Alignment.bottomRight,
                        textSide: TextAlign.end,
                        bubbleColor: Colors.deepPurple,
                        textColor: Colors.white,
                        dateTime: dateT,
                        textAlign: TextAlign.right,
                      );
                    }else {
                      bubble = ChatBubble(
                        message: message['message'],
                        messageSide: Alignment.bottomLeft,
                        textSide: TextAlign.start,
                        bubbleColor: Colors.white,
                        textColor: Colors.black,
                        dateTime: dateT,
                        textAlign: TextAlign.left,
                      );
                    }
                    return bubble;
                  }
                

                );

              },
            ),

          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
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
                        hintText: 'Enter your message here',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send, 
                            color: Colors.deepPurple, 
                            size: 30,
                          ),
                          onPressed: (){
                            if(messageController.text.isNotEmpty){
                              _model.insertMessage(widget.chatRoomId, messageController.text, widget.tutorData['uid']);
                              messageController.clear();

                            }
                          }
                        ),
                      ),  
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {

  final TextAlign textSide;
  final Alignment messageSide;
  final String message; /*time*/
  final Color bubbleColor, textColor;
  final String dateTime;
  final TextAlign textAlign;


  ChatBubble({this.textSide, this.messageSide, this.message, this.bubbleColor, this.textColor, this.dateTime, this.textAlign});

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
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            alignment: messageSide,
            child: Text(
              dateTime,
              style: TextStyle(fontSize:12),
              textAlign: textAlign,
            )
            
          ),

        ],
      )
    );
  }
}
