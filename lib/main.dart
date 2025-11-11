import 'package:flutter/material.dart';
import 'db/db_helper.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPage(),
    );
  }
}
class TodoPage extends StatefulWidget{
  @override
  State<TodoPage> createState() => _TodoPageState();
}
class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  final db = DBHelper.instance;
  List<Map<String, dynamic>>  tasks = [];

  void loadData() async {
    final data = await db.queryAllRows();
    setState(() =>
      tasks = data
    );
  }
  @override
  void initstate() {
    super.initState();
    loadData();
  }

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      int id= await db.insert({
        'title': _controller.text,
        // 'description': '',
        // 'isCompleted': 0,
      });
      _controller.clear();
       debugPrint("Inserted row id: $id"); // ✅ Check console output
      loadData();
    }
  }
  void deleteTask(int id) async {
    await db.delete(id);
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'New Task',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task['title']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(task['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
