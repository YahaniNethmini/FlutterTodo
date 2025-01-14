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
      elevation: 10,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(20),
        leading: Icon(
          Icons.task_alt,
          color: task.isCompleted
              ? Colors.green
              : Colors.grey,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
        Divider(),
            Text(
              '${task.dueDate!.toLocal()}'.split(' ')[0],
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: () => taskController.toggleTaskCompletion(index),
            icon: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: task.isCompleted
                  ? Colors.green
                  : Colors.grey,
            )
        ),
      ),
    );
  }
}
