import 'package:flutter/material.dart';
import 'package:to_do_list/models/task.dart';

// import screens
import 'package:to_do_list/screen/add_task_screen.dart';
import 'package:to_do_list/screen/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id: (_) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        // Nếu Navigator được gọi và màn hình đến là AddTaskScreen
        if (settings.name == AddTaskScreen.id) {
          return MaterialPageRoute(
            builder: (context) {
              // Nếu có dữ liệu truyền vào thì đưa qua constructor
              if (settings.arguments != null) {
                Task task = settings.arguments;
                return AddTaskScreen(task);
              }
              // default là null
              return AddTaskScreen(null);
            },
            
          );
        }
        return null;
      },
    );
  }
}