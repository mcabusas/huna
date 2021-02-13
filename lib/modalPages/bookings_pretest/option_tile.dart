import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTile({this.option, this.description, this.correctAnswer, this.optionSelected});
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(

              border: Border.all(
                color: Colors.black
              ),
              color: widget.description == widget.optionSelected ? 
                widget.optionSelected == widget.correctAnswer ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7) : Colors.white,

              borderRadius: BorderRadius.circular(30)

            ),
            alignment: Alignment.center,
            child: Text(
              widget.option,
              style: TextStyle(
                //color: widget.optionSelected == widget.description ? 
                //widget.correctAnswer == widget.optionSelected ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7) : 
                color: Colors.black
              )
            )
          ),
          SizedBox(width: 8.0,),

          Text(
            widget.description,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black
            )
          )
        ],
      )
      
    );
  }
}