import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_sample/model/note.dart';

class DatabaseHelper{

  static DatabaseHelper _dbHelper;
  static Database _db;

  String table = 'note_table';
  String cid = 'id';
  String cTitle = 'title';
  String cDescription = 'desc';
  String cDate = 'date';
  String cPriority = 'priority';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(DatabaseHelper==null){
      _dbHelper=DatabaseHelper._createInstance();
    }
      return _dbHelper;
  }

  Future<Database> get database async{

    if(_db==null)
      _db=await initializeDB();
    return _db;
  }

  Future<Database> initializeDB() async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path + 'note.db';

    var noteDB=await openDatabase(path,version: 1,onCreate: _createDb);
    return noteDB;
  }

  void _createDb(Database db,int newVer) async{

    await db.execute('CREATE TABLE $table($cid INTEGER PRIMARY KEY AUTOINCREMENT, $cTitle TEXT, '
        '$cDescription TEXT, $cPriority INTEGER, $cDate TEXT)');

  }

  Future<List<Map<String,dynamic>>> getNoteMap() async{
    Database db=await this.database;
    
    var result=await db.query(table,orderBy: '$cPriority ASC');
    return result;
  }

// Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(table, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(table, note.toMap(), where: '$cid = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $cid = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async{

    var noteMapList =await getNoteMap();
    int count=noteMapList.length;

    List<Note> noteList=List<Note>();

    for(int i=0;i<count;i++){
      noteList.add(Note.fromMap(noteMapList[i]));
    }

    return noteList;
    
  }

}