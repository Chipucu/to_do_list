import 'package:flutter/material.dart';
import 'package:to_do_list/database/tasks_db';
import 'add_task_screen.dart';
import 'package:to_do_list/screen/add_task_screen.dart'; // new
import '../models/task.dart'; // new

// Vì sau này mình sẽ lấy dữ liệu từ Database đổ vào ListView
// nên dùng StatefulWidget để có thể thay đổi được UI
class MainScreen extends StatefulWidget {
  // Mình đặt id để xíu nữa mình dùng trong routes
  static const id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    List<Task> tasks = []; // new

  Future getTasks() async { // new
    // Lấy tất cả task và gán vào list tasks
    final db = TasksDB(); // new
    tasks = await db.getTasks(); // new
    setState(() {}); // new
  } // new
    Future deleteTask(int id) async { // new
    // Xóa task ở record có id là id được truyền vào
    final db = TasksDB(); // new
    await db.delete(id); // new
    tasks = await db.getTasks(); // new
    await getTasks(); // new
    setState(() {}); // new
  } // new

  @override // new
  void initState() { // new
    getTasks(); // new
    super.initState(); // new
  } // new
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Một cái AppBar đơn giản hiển thị tên app
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      // FAB sẽ là biểu tượng Add (ý là add task vào ý)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate sang màn hình add task và chờ kết quả trả về
          final result = await Navigator.pushNamed(context, AddTaskScreen.id); // Edited
          // Nếu kết quả trả về là true tức là có thêm task nên ta sẽ cập nhật lại list tasks
          if (result == true) getTasks(); // new
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        // Mình demo với 9 item nha
        // Phần sau mình sẽ lấy data từ database sau
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          // Mỗi item là một ListTile
          return ListTile(
            title: Text(tasks[index].task),
            trailing: PopupMenuButton(
              onSelected: (i) async {
                if (i == 0) {
                  // Code chuyển sang màn hình edit
                 // Tương tự như FAB add task, ta chờ xem có update task thì up
                  // lại list tasks
                  final result = await Navigator.pushNamed( // Edited
                    context,  // new
                    AddTaskScreen.id,  // new
                    // truyền task qua màn hình add task để edit
                    arguments: tasks[index],  // new
                  );  // new
                  if (result == true) getTasks(); 
                } else if (i == 1) {
                  // Hiện dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm your deletion'),
                        content: Text(
                            'This task will be deleted permanently. Do you want to do it?'),
                        actions: <Widget>[
                          // Nút hủy, nhấn vào chỉ pop cái dialog đi thôi không làm gì thêm
                          FlatButton(
                            onPressed: () {
                               // delete task có id  là id của item hiện tại
                              deleteTask(tasks[index].id); // new
                              Navigator.pop(context);
                            },
                            child: Text('CANCEL'),
                          ),
                          FlatButton(
                            onPressed: () {
                              // Xóa task...
                              Navigator.pop(context);
                            },
                            child: Text(
                              'DELETE',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ];
              },
            ),
          );
        },
      ),
    );
  }
}