import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huna/bookings/bookings_view.dart';
import '../bookings_pretest_model.dart';
import 'results.dart';

class ResultsPage extends StatefulWidget {
  final pretestId;
  ResultsPage({this.pretestId});
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  PretestModel _model = new PretestModel();
  QuerySnapshot questionSnapshot;

  Results getResults(DocumentSnapshot qSnapshot){
    Results resultsModel = new Results();

    resultsModel.question = qSnapshot.data()['question'];
    resultsModel.correctAnswer = qSnapshot.data()['answer1'];
    resultsModel.studentsAnswer = qSnapshot.data()['students_answer'];

    return resultsModel;

  }

  @override
  void initState() {
    super.initState();
    _model.getQuestions(widget.pretestId).then((value){
      setState(() {
        questionSnapshot = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bookings()),
              );
            }),
        title: Text('Results Page'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
        onPressed: (){
          print(widget.pretestId);
          //_model.updatePretestStatus(widget.pretestId);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionSnapshot == null ? 
              Container(child: Center(child: CircularProgressIndicator())):
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: questionSnapshot.docs.length,
                itemBuilder: (context, index){
                  return ResultsTile(
                    results: getResults(questionSnapshot.docs[index]),
                    index: index,
                    // model: _model,
                    // id: questionSnapshot.docs[index].id,
                    // pretestId: widget.pretestId
                  );
                },
              )
            ],
          )
        ),
      )
    );
  }
}

class ResultsTile extends StatefulWidget {
  final Results results;
  final int index;
  ResultsTile({this.results, this.index});
  @override
  _ResultsTileState createState() => _ResultsTileState();
}

class _ResultsTileState extends State<ResultsTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${widget.index+1}) ${widget.results.question}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400
            ),
          ),
          
          SizedBox(height: 15),

          Text(
            'Correct Answer: ${widget.results.correctAnswer}',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black
            )
          ),
          SizedBox(height: 15,),

          Text(
            'Your Answer: ${widget.results.studentsAnswer}',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black
            )
          ),

          SizedBox(height: 15),

          widget.results.correctAnswer == widget.results.studentsAnswer ? 
            Text(
                'Correct',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15
                ),
              ) :
            Text(
              'Incorrect',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15
              ),
            ),

            SizedBox(height: 15),

            Divider()
        ],
      )
    );
  }
}