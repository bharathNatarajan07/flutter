import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqlite_sample/util/helper_2.dart';
import 'package:sqlite_sample/model/note.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class NoteDetail extends StatefulWidget{

  final Note note;
  final String barTitle;
  NoteDetail(this.note,this.barTitle);

  @override
  State<StatefulWidget> createState() {

    return NoteDetailState(this.note,this.barTitle);
  }
}

class NoteDetailState extends State<NoteDetail>{

  Note note;
  static var prior=["high","low"];

  DatabaseHelper databaseHelper=DatabaseHelper();

  String barTitle;

  TextEditingController tc=TextEditingController();
  TextEditingController dc=TextEditingController();

  NoteDetailState(this.note,this.barTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle=Theme.of(context).textTheme.title;

    tc.text=note.title;
    dc.text=note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(barTitle),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: prior.map((String dropDownStringItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),

                  style: textStyle,

                  value: getPriorityAsString(note.priority),

                  onChanged: (val){
                    setState(() {
                      updatePriorityAsInt(val);
                    });
                  }
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                controller: tc,
                style: textStyle,
                onChanged: (value){
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelStyle: textStyle,
                  labelText: 'title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                controller: dc,
                style: textStyle,
                onChanged: (value){
                    updateDesc();
                },
                decoration: InputDecoration(
                    labelStyle: textStyle,
                    labelText:'Description' ,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child:Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Save',textScaleFactor: 1.5,),
                        onPressed:(){
                          setState(() {
                            save();
                          });
                        }
                    ),
                  ),

                  Container(width: 5.0,),

                  Expanded(
                    child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Delete',textScaleFactor: 1.5,),
                        onPressed:(){
                          setState(() {
                            delete();
                          });
                        }
                    ),
                  )

                ],
              )
            )

          ],
        ),
      ),
    );
  }
  void updatePriorityAsInt(String val){
    switch(val){
      case 'high': note.priority=1;break;
      case 'low': note.priority=2;break;
    }
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  String getPriorityAsString(int val){
    String priority;
    switch(val){
      case 1: priority=prior[0];break;
      case 2: priority=prior[1];break;
    }
    return priority;
  }

  void updateTitle(){
    note.title=tc.text;
    cpost();
  }
  void updateDesc(){
    note.description=dc.text;
  }

  void save() async{

    moveToLastScreen();

    note.date=DateFormat.yMMMd().format(DateTime.now());

    int result;
    if(note.id!=null){
      result= await databaseHelper.updateNote(note);
    }
    else{
      result= await databaseHelper.insertNote(note);
    }

    if(result!=0){
      showAlert('status','Note Saved');
    }
    else{
      showAlert('status','Note Not Saved');
    }

  }

  void delete() async{
    moveToLastScreen();

    if(note.id==null){
        return;
    }
    else{
      int result=await databaseHelper.deleteNote(note.id);
      if(result!=0){
        showAlert('Satus', 'Deleted');
      }
      else{
        showAlert('Satus', 'Not Deleted');
      }
    }
    Navigator.pop(context,true);
  }

  void showAlert(String title,String message){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
      builder: (_)=>alertDialog
    );
  }

  cpost() async{
    var j=json.encode("name""${tc.text}");
    var resp=await http.post("http://10.1.31.19:8081/ihspdc/rest/putGroceries.json",body: j);
    print(resp.body);
  }

}