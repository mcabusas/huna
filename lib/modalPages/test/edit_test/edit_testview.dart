import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import 'edit_testmodal.dart';
import 'edit_question.dart';

class EditPage extends StatefulWidget {
  final pretestId;
  EditPage({this.pretestId});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  EditPretestModal _model = new EditPretestModal();
   Stream questionSnapshot;
  final _key = GlobalKey<FormState>();
  Map<String, dynamic> questionData;

  

  @override
  void initState() {
    super.initState();
    print(widget.pretestId);
    questionSnapshot = _model.getQuestions(widget.pretestId);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Bookings()),
              // );
            }),
        title: Text('Edit Pre-test/Post-test'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
        onPressed: (){
          print(widget.pretestId);
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookings()),
              );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              StreamBuilder(
                stream: questionSnapshot,
                builder: (context, snapshot){
                  if(snapshot.data == null){
                    return new Container(child: Center(child: Text('null')));
                  }
                    return new ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot questions = snapshot.data.docs[index];
                        return new Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text(
                                    'Q${index+1}) ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18
                                    )
                                  ),

                                  SizedBox(width: 10),
                                  
                                  Text(
                                    questions['question'],
                                    style: TextStyle(
                                      fontSize: 15
                                    )
                                  )

                                ]
                              ),

                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [

                                    Row(
                                      children: [
                                        Text(
                                          'Ans.1 (Correct Answer) ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15
                                          )
                                        ),

                                        SizedBox(width: 10),
                                        
                                        Text(
                                          questions['answer1'],
                                          style: TextStyle(
                                            fontSize: 15
                                          ),
                                        )

                                      ]
                                    ),

                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Text(
                                          'Ans.2',
                                          style: TextStyle(
                                            color: Colors.black
                                          )
                                        ),

                                        SizedBox(width: 10),
                                        
                                        Text(
                                          questions['answer2']
                                        )

                                      ]
                                    ),

                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Text(
                                          'Ans.3 ',
                                          style: TextStyle(
                                            color: Colors.black
                                          )
                                        ),

                                        SizedBox(width: 10),
                                        
                                        Text(
                                          questions['answer3']
                                        )

                                      ]
                                    ),

                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Text(
                                          'Ans. 4 ',
                                          style: TextStyle(
                                            color: Colors.black
                                          )
                                        ),

                                        SizedBox(width: 10),
                                        
                                        Text(
                                          questions['answer4']
                                        )

                                      ]
                                    ),
                                  ],
                                )
                              ),

                              RaisedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    questionData = {
                                      'question': questions['question'],
                                      'a1': questions['answer1'],
                                      'a2': questions['answer2'],
                                      'a3': questions['answer3'],
                                      'a4': questions['answer4'],
                                      'qid': questions.id,
                                      'test_id': widget.pretestId
                                    };
                                  });
                                  //print(questionData);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditQuestion(questionData: questionData)),
                                    );
                                  
                                },
                                icon: Icon(Icons.assignment_late),
                                label: Text('Update Question'),
                                color: Colors.purple,
                                textColor: Colors.white,
                              ),

                              SizedBox(height: 15),

                              Divider(color: Colors.black)

                            ]
                          )
                        );
                      }
                    );
                  
                }
              )

              // StreamBuilder(
              //   stream: questionSnapshot,
              //   builder: (context, snapshot){
              //     if(snapshot.data == null){
              //       return new Container(child: Center(child: Text('null')));
              //     }else{
              //       return new  ListView.builder(
              //         shrinkWrap: true,
              //         padding: EdgeInsets.all(15.0),
              //         itemCount: snapshot.data.docs.length,
              //         itemBuilder: (context, index){
              //           DocumentSnapshot question = snapshot.data.docs[index];
              //           return Form(
              //             key: _key,
              //             child: Column(
              //               children: [
              //                 TextFormField(
              //                   validator: (value){
              //                     if(value.isEmpty){
              //                       return 'Please enter a new question';
              //                     }
              //                     return null;
              //                   },
              //                   initialValue: "Q${index+1} ${snapshot.data.docs.length}",
              //                 ),

              //                 // TextFormField(
              //                 //   validator: (value){
              //                 //     if(value.isEmpty){
              //                 //       return 'Please enter a new question';
              //                 //     }
              //                 //     return null;
              //                 //   },
              //                 //   initialValue: "Q${index+1} ${question['question']}",
              //                 // ),
              //               ]
              //             )
              //           );
              //         }
              //       );
              //     }
              //   },
              // )

            ],
          )
        ),
      )
    );
  }
}

// class ResultsTile extends StatefulWidget {
//   final Results results;
//   final int index;
//   ResultsTile({this.results, this.index});
//   @override
//   _ResultsTileState createState() => _ResultsTileState();
// }

// class _ResultsTileState extends State<ResultsTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Q${widget.index+1}) ${widget.results.question}',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.w400
//             ),
//           ),
          
//           SizedBox(height: 15),

//           Text(
//             'Correct Answer: ${widget.results.correctAnswer}',
//             style: TextStyle(
//               fontSize: 17,
//               color: Colors.black
//             )
//           ),
//           SizedBox(height: 15,),

//           Text(
//             "Student's Answer: ${widget.results.studentsAnswer}",
//             style: TextStyle(
//               fontSize: 17,
//               color: Colors.black
//             )
//           ),

//           SizedBox(height: 15),

//           widget.results.correctAnswer == widget.results.studentsAnswer ? 
//             Text(
//                 'Correct',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 15
//                 ),
//               ) :
//             Text(
//               'Incorrect',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: 15
//               ),
//             ),

//             SizedBox(height: 15),

//             Divider()
//         ],
//       )
//     );
//   }
// }