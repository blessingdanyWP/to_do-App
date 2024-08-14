import 'package:flutter/material.dart';
import 'package:to_do_app/screens/todolist.dart';

void main(){
  runApp(Myapp()); 
  
}


class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(),
      home: TodoListPage(),
    );
  }
}