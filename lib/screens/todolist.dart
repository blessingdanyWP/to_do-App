import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchtodo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Todo List')),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchtodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text('NO Todo Item',
            style: Theme.of(context).textTheme.headlineLarge,),),
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, nums) {
                  final item = items[nums] as Map;
                  final id = item['_id'] as String;
            
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${nums + 1}')),
                      title: Text(
                        item['title'],
                      ),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            navigateToEditPage(item);
                          } else if (value == 'delete') {
                            deletebyId(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete '),
                              value: 'delete',
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: Text('Add Todo List')),
    );
  }

  Future <void> navigateToAddPage() async {
    final way = MaterialPageRoute(
      builder: (context) => AddToDoPage(),
    );
    await Navigator.push(context, way);
    setState(() {
      isLoading= true;
    });

    fetchtodo();
  }

  Future<void> navigateToEditPage(Map item) async{
    final way = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo:item),
    );
    await Navigator.push(context, way);
    setState(() {
      isLoading= true;
    });
    fetchtodo();
  }

  Future<void> deletebyId(String id) async {
    final link = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(link);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      
      final filter = items.where((element) => element['_id'] != id).toList();
      
      setState(() {
        items = filter;
      });
    } else {
            showErrorMessage('failed');

    }
  }

  Future<void> fetchtodo() async {
    final link = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(link);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }



  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(
      message, style: TextStyle(color: Colors.white),),
    backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}
