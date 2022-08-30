import 'package:flutter/material.dart';
import 'package:to_do_list/database/tasks_db';// new
import '../models/task.dart'; // new

class AddTaskScreen extends StatefulWidget {
  // Mình đặt id dùng trong routes
  static const id = 'add_task_screen';
  final Task task; // new

  AddTaskScreen( this.task); // 

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskController = TextEditingController();
  bool _inSync = false;
   String _taskError= "";
   @override 
  void initState() {
    Task task = widget.task;
    // Nếu có task được truyền qua màn hình add, tức là đang chỉnh sửa task
    if (task != null) {
      // Thực hiện gán task vào TextField
      _taskController.text = task.task; 
    } 
    super.initState(); 
  } 

  void addTask() async {
    if (_taskController.text.isEmpty) { 
      setState(() { 
        _taskError = 'Please enter this field'; 
      }); 
      return null; 
    } 
    setState(() { 
      _taskError = ""; 
      _inSync = true; 
    }); 
    final db = TasksDB(); 
    final task = Task( 
      id: widget.task.id,
      task: _taskController.text.trim(), 
    );
    // insert task vào database
    await db.insert(task); 
    setState(() { 
      _inSync = false; 
    }); 
    // Trở về màn hình chính với giá trị trả về là true
    Navigator.pop(context, true); 
  } 

  void updateTask() async {
    if (_taskController.text.isEmpty) { 
      setState(() {
        _taskError = 'Please enter this field'; 
      });
      return null; 
    } 
    setState(() { 
      _taskError = ""; 
      _inSync = true; 
    }); 
    final db = TasksDB(); 
    // Update task với giá trị mới ở record có id là id của task truyền vào
    final task = Task( 
      id: widget.task.id,
      task: _taskController.text.trim(),
    );
    await db.update(task);
    setState(() { 
      _inSync = false; 
    }); 
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add task'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // Nút back trên appbar sẽ không nhấn được khi đang lưu dữ liệu
          onPressed: !_inSync
              ? () {
                  Navigator.pop(context);
                }
              : null,
        ),
        actions: <Widget>[
          // Tương tự, như nút back tránh trường hợp user nhấn 2 lần
          !_inSync
              ? IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    
                  },
                )
              : Icon(Icons.refresh),
        ],
        elevation: 0.0,
        // textTheme: TextTheme(
        //   title: Theme.of(context).textTheme.title,
        // ),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: WillPopScope(
        // Ngăn nút người dùng nhấn back trên android khi đang lưu dữ liệu
        onWillPop: () async {
          if (!_inSync) return true;
          return false;
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: 'Task',
              errorText: _taskError,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}