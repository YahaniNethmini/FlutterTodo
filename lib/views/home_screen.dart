import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_flutter/controllers/task_controller.dart';
import 'package:todo_flutter/models/task_model.dart';

import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
            'My Tasks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Obx(() {
        return taskController.taskList.isEmpty ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                  Icons.article_rounded,
                  color: Colors.deepPurple,
                  size: 80,
              ),
              SizedBox(height: 10),
              Text(
                "No Tasks Yet!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        )
        :ListView.builder(
          itemCount: taskController.taskList.length,
          itemBuilder: (context, index) {
            var task = taskController.taskList[index];
            return Slidable(
              key: ValueKey(index),
              startActionPane: ActionPane(
                  motion: DrawerMotion(),
                  extentRatio: 0.25, children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(15),
                      autoClose: true,
                      onPressed: (context)=> Get.to(()=> AddTaskScreen(
                        task: task,
                        index: index,
                      )),
                      // onPressed: (v){},
                      backgroundColor: Colors.deepPurple,
                      icon: Icons.edit,
                      label: "Edit",
                    )
              ]),
              endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  extentRatio: 0.25, children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(15),
                  autoClose: true,
                  onPressed: (context) => taskController.deleteTask(index),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: "Delete",
                )
              ]),
              child: taskCard(task, index),
            ).animate().fade().slide(duration: 300.ms);
          },
        );
      }),
    ),
    floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: (){
          Get.to(()=> AddTaskScreen());
        },
        child: Icon(Icons.add),
    ),
    );
  }

  Widget taskCard(Task task, int index) {
    return Card(
      elevation: 3,
      child: ListTile(),
    );
  }
}
