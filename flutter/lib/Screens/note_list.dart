import 'package:flutter/material.dart';
import 'note_detail.dart';
import 'package:sqlite_sample/model/note.dart';
import 'package:sqlite_sample/util/helper_2.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList>{

  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note> noteList;
  int count=0;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
        noteList = List<Note>();
        updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
      ),
      body:getListView(),
      floatingActionButton: FloatingActionButton(onPressed:(){
        navigateToDetail(Note('','',2),'Add Note');
      },
        child:Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  ListView getListView() {

    TextStyle titleStyle=Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int pos) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[pos].priority),
              child: getPriorityIcon(this.noteList[pos].priority),
            ),
            title: Text(this.noteList[pos].title, style: titleStyle,),
            subtitle: Text(this.noteList[pos].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: (){
                _delete(context, noteList[pos]);
              },
            ),


            onTap: () {
              navigateToDetail(this.noteList[pos],'Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
    Color getPriorityColor(int priority){
      switch(priority){
        case 1: return Colors.red;
        break;
        case 2:return Colors.yellow;
        break;

        default:return Colors.yellow;
      }
    }

    Icon getPriorityIcon(int priority){
      switch(priority){
        case 1: return Icon(Icons.play_arrow);
        break;
        case 2:return Icon(Icons.keyboard_arrow_right);
        break;

        default:return Icon(Icons.keyboard_arrow_right);
      }
    }

    void _delete(BuildContext context,Note note) async{

    int result=await databaseHelper.deleteNote(note.id);
    if(result!=0)
      {
        _showSnackBar(context, 'Deleted Successfully');
        updateListView();
      }
    }

    void _showSnackBar(BuildContext context,String message){

      final snackBar=SnackBar(content:Text(message));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    void updateListView(){

      final Future<Database> dbFuture=databaseHelper.initializeDatabase();
      dbFuture.then((d){
        Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
        noteListFuture.then((noteList){
          setState(() {
            this.noteList=noteList;
            this.count=noteList.length;
          });
        });
      });

    }

}