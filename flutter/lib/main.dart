import 'package:flutter/material.dart';
import 'package:sqlite_sample/Screens/note_list.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        home:new Api()
    );
  }
}

class Api extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ApiState();
  }

}

class ApiState extends State<Api> {


  List data;
  String s1, s2;
  String val1, val2;

  TextEditingController tc = new TextEditingController();
  TextEditingController pc = new TextEditingController();


  Future<Null> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://swapi.co/api/people"),
        headers: {
          "Accept": "application/json"
        }
    );
    setState(() {
      var reqBody = json.decode(response.body);
      data = reqBody["results"];
      s1 = data[0]["height"];
      s2 = data[0]["mass"];
    });


    print(s1);
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle ts = Theme
        .of(context)
        .textTheme
        .subhead;

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Login"),
        ),
        body: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextField(
                style: ts,
                onSubmitted: login,
                decoration: InputDecoration(
                    labelText: "User Id",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextField(
                style: ts,
                onSubmitted: pass,
                decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                    )
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: new Center(
                child: RaisedButton(
                  onPressed: navigate,
                  child: Text("Login"),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }


  void login(String value) {
    //print(val1);
    setState(() {
      val1 = value;
    });
  }

  void pass(String value) {
    // print(val2);
    setState(() {
      val2 = value;
    });
  }

  void navigate() {
    if (val1 == s1 && val2 == s2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return new NoteList();
      }));
    }
    else {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Status"),
        content: Text("Not Working"
            "The id is $s1"
            "The Password is $s2"),
      );
      showDialog(context: context,
          builder: (_) => alertDialog
      );
    }
  }
}







/*void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: NoteList(),
    );
  }
}*/
